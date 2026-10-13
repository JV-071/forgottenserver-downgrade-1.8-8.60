// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "fileloader.h"

#include <algorithm>
#include <array>
#include <limits>
#include <new>
#include <zlib.h>

#include <stack>

namespace OTB {

constexpr Identifier wildcard = {{'\0', '\0', '\0', '\0'}};
namespace {
constexpr size_t GZIP_BUFFER_SIZE = 1024 * 1024;
constexpr size_t MAX_DECOMPRESSED_OTB_SIZE = 512 * 1024 * 1024;

bool isGzipInput(const char* data, size_t size)
{
	return size >= 2 && static_cast<unsigned char>(data[0]) == 0x1F && static_cast<unsigned char>(data[1]) == 0x8B;
}

bool decompressGzipInput(const char* input, size_t inputSize, std::vector<char>& output)
{
	if (inputSize > std::numeric_limits<uInt>::max()) {
		return false;
	}

	z_stream stream{};
	stream.next_in = reinterpret_cast<Bytef*>(const_cast<char*>(input));
	stream.avail_in = static_cast<uInt>(inputSize);
	if (inflateInit2(&stream, MAX_WBITS + 16) != Z_OK) {
		return false;
	}

	// The gzip trailer is only a reservation hint; the hard limit below remains authoritative.
	if (inputSize >= sizeof(uint32_t)) {
		uint32_t hintedSize = 0;
		std::memcpy(&hintedSize, input + inputSize - sizeof(hintedSize), sizeof(hintedSize));
		if (hintedSize > 0 && hintedSize <= MAX_DECOMPRESSED_OTB_SIZE) {
			try {
				output.reserve(hintedSize);
			} catch (const std::bad_alloc&) {
				// A malformed hint or memory pressure must not stop the incremental path.
			}
		}
	}

	int result = Z_OK;
	do {
		if (output.size() >= MAX_DECOMPRESSED_OTB_SIZE) {
			inflateEnd(&stream);
			return false;
		}

		const size_t offset = output.size();
		const size_t chunkSize = std::min(GZIP_BUFFER_SIZE, MAX_DECOMPRESSED_OTB_SIZE - offset);
		try {
			output.resize(offset + chunkSize);
		} catch (const std::bad_alloc&) {
			inflateEnd(&stream);
			return false;
		} catch (const std::length_error&) {
			inflateEnd(&stream);
			return false;
		}

		stream.next_out = reinterpret_cast<Bytef*>(output.data() + offset);
		stream.avail_out = static_cast<uInt>(chunkSize);
		result = inflate(&stream, Z_NO_FLUSH);
		output.resize(offset + chunkSize - stream.avail_out);
		if (result != Z_OK && result != Z_STREAM_END) {
			inflateEnd(&stream);
			return false;
		}
	} while (result != Z_STREAM_END);

	inflateEnd(&stream);
	return true;
}
} // namespace

Loader::Loader(const std::string& fileName, const Identifier& acceptedIdentifier, bool allowCompressed)
{
	std::error_code error;
	fileContents.map(fileName, error);
	if (error) {
		throw InvalidOTBFormat{};
	}

	const char* data = fileContents.data();
	const size_t size = fileContents.size();
	compressedInput = isGzipInput(data, size);
	if (compressedInput) {
		if (!allowCompressed) {
			throw CompressedOTBFormat{};
		}
		if (!decompressGzipInput(data, size, decompressedContents)) {
			throw OTBDecompressionError{};
		}
		data = decompressedContents.data();
	}

	constexpr auto minimalSize = sizeof(Identifier) + sizeof(Node::START) + sizeof(Node::type) + sizeof(Node::END);
	const size_t contentSize = compressedInput ? decompressedContents.size() : size;
	if (contentSize <= minimalSize) {
		throw InvalidOTBFormat{};
	}

	Identifier fileIdentifier;
	std::copy(data, data + fileIdentifier.size(), fileIdentifier.begin());
	if (fileIdentifier != acceptedIdentifier && fileIdentifier != wildcard) {
		throw InvalidOTBFormat{};
	}
}
using NodeStack = std::stack<Node*, std::vector<Node*>>;
static Node& getCurrentNode(const NodeStack& nodeStack)
{
	if (nodeStack.empty()) {
		throw InvalidOTBFormat{};
	}
	return *nodeStack.top();
}

const Node& Loader::parseTree()
{
	const char* data = compressedInput ? decompressedContents.data() : fileContents.data();
	const size_t size = compressedInput ? decompressedContents.size() : fileContents.size();
	const auto contentEnd = data + size;
	auto it = data + sizeof(Identifier);
	if (static_cast<uint8_t>(*it) != Node::START) {
		throw InvalidOTBFormat{};
	}
	root.type = *(++it);
	root.propsBegin = ++it;
	NodeStack parseStack;
	parseStack.push(&root);

	for (; it != contentEnd; ++it) {
		switch (static_cast<uint8_t>(*it)) {
			case Node::START: {
				auto& currentNode = getCurrentNode(parseStack);
				if (currentNode.children.empty()) {
					currentNode.propsEnd = it;
				}
				currentNode.children.emplace_back();
				auto& child = currentNode.children.back();
				if (++it == contentEnd) {
					throw InvalidOTBFormat{};
				}
				child.type = *it;
				child.propsBegin = it + sizeof(Node::type);
				parseStack.push(&child);
				break;
			}
			case Node::END: {
				auto& currentNode = getCurrentNode(parseStack);
				if (currentNode.children.empty()) {
					currentNode.propsEnd = it;
				}
				parseStack.pop();
				break;
			}
			case Node::ESCAPE: {
				if (++it == contentEnd) {
					throw InvalidOTBFormat{};
				}
				break;
			}
			default: {
				break;
			}
		}
	}
	if (!parseStack.empty()) {
		throw InvalidOTBFormat{};
	}

	return root;
}

bool Loader::getProps(const Node& node, PropStream& props)
{
	auto size = std::distance(node.propsBegin, node.propsEnd);
	if (size == 0) {
		return false;
	}

	// Most OTBM property ranges do not contain escaped control bytes. Point the
	// stream at the mapped file directly in that common case and avoid a copy.
	const char* escapePtr = static_cast<const char*>(std::memchr(node.propsBegin, Node::ESCAPE, static_cast<size_t>(size)));
	if (escapePtr == nullptr) {
		props.init(node.propsBegin, static_cast<size_t>(size));
		return true;
	}

	// Slow path: unescape into propBuffer. An ESCAPE (0xFD) byte marks the
	// next byte as a literal. Copy escape-free runs in bulk, handle escaped
	// bytes individually, and step over adjacent escapes without paying a
	// memchr call per byte (dense escape clusters would otherwise degrade).
	propBuffer.resize(size);
	char* dst = propBuffer.data();
	const char* src = node.propsBegin;
	const char* const srcEnd = node.propsEnd;
	const char* esc = escapePtr; // first escape, already located by memchr above

	while (true) {
		dst = std::copy(src, esc, dst); // clean run before the escape
		src = esc + 1;                  // skip the ESCAPE marker
		if (src == srcEnd) {
			break; // trailing lone ESCAPE: nothing to keep
		}
		*dst++ = *src++; // escaped byte kept literally (may itself be 0xFD)
		if (src == srcEnd) {
			break;
		}
		if (*src == static_cast<char>(Node::ESCAPE)) {
			esc = src; // adjacent escape: no scan needed
			continue;
		}
		esc = static_cast<const char*>(std::memchr(src + 1, Node::ESCAPE, srcEnd - src - 1));
		if (!esc) {
			dst = std::copy(src, srcEnd, dst); // tail after the last escape
			break;
		}
	}

	props.init(propBuffer.data(), std::distance(propBuffer.data(), dst));
	return true;
}

} // namespace OTB
