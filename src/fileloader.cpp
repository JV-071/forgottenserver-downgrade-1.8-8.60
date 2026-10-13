// Copyright 2023 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "fileloader.h"

#include <algorithm>
#include <array>
#include <archive.h>
#include <archive_entry.h>
#include <cctype>
#include <limits>
#include <new>
#include <zlib.h>

#include <stack>

namespace OTB {

constexpr Identifier wildcard = {{'\0', '\0', '\0', '\0'}};
namespace {
constexpr size_t GZIP_BUFFER_SIZE = 1024 * 1024;
constexpr size_t ARCHIVE_BUFFER_SIZE = 64 * 1024;
constexpr size_t MAX_DECOMPRESSED_OTB_SIZE = 512 * 1024 * 1024;

bool isGzipInput(const char* data, size_t size)
{
	return size >= 2 && static_cast<unsigned char>(data[0]) == 0x1F && static_cast<unsigned char>(data[1]) == 0x8B;
}

bool hasPrefix(const char* data, size_t size, std::initializer_list<unsigned char> prefix)
{
	if (size < prefix.size()) {
		return false;
	}

	return std::equal(prefix.begin(), prefix.end(), reinterpret_cast<const unsigned char*>(data));
}

bool isArchiveInput(const char* data, size_t size)
{
	return hasPrefix(data, size, {'P', 'K', 0x03, 0x04}) || hasPrefix(data, size, {'P', 'K', 0x05, 0x06}) ||
	       hasPrefix(data, size, {'P', 'K', 0x07, 0x08}) || hasPrefix(data, size, {'R', 'a', 'r', '!', 0x1A, 0x07}) ||
	       hasPrefix(data, size, {0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C}) || hasPrefix(data, size, {'B', 'Z', 'h'}) ||
	       hasPrefix(data, size, {0xFD, 0x37, 0x7A, 0x58, 0x5A, 0x00}) || hasPrefix(data, size, {'L', 'Z', 'I', 'P'}) ||
	       hasPrefix(data, size, {0x5D, 0x00, 0x00}) || hasPrefix(data, size, {0x1F, 0x9D}) || hasPrefix(data, size, {0x28, 0xB5, 0x2F, 0xFD}) ||
	       hasPrefix(data, size, {0x04, 0x22, 0x4D, 0x18});
}

bool matchesArchiveMapEntry(const char* path, std::string_view expectedName)
{
	if (!path) {
		return false;
	}

	std::string_view name{path};
	const auto separator = name.find_last_of("/\\");
	if (separator != std::string_view::npos) {
		name.remove_prefix(separator + 1);
	}
	if (name.size() < 5 || !std::equal(name.end() - 5, name.end(), ".otbm", [](char lhs, char rhs) {
		return std::tolower(static_cast<unsigned char>(lhs)) == std::tolower(static_cast<unsigned char>(rhs));
	})) {
		return false;
	}

	return expectedName.empty() || (name.size() == expectedName.size() && std::equal(name.begin(), name.end(), expectedName.begin(), [](char lhs, char rhs) {
		return std::tolower(static_cast<unsigned char>(lhs)) == std::tolower(static_cast<unsigned char>(rhs));
	}));
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

bool readArchiveEntry(struct archive* archive, std::vector<char>& output)
{
	std::array<char, ARCHIVE_BUFFER_SIZE> buffer{};
	while (true) {
		const la_ssize_t read = archive_read_data(archive, buffer.data(), buffer.size());
		if (read == 0) {
			return true;
		}
		if (read < 0 || static_cast<size_t>(read) > MAX_DECOMPRESSED_OTB_SIZE - output.size()) {
			return false;
		}

		try {
			output.insert(output.end(), buffer.begin(), buffer.begin() + read);
		} catch (const std::bad_alloc&) {
			return false;
		} catch (const std::length_error&) {
			return false;
		}
	}
}

bool decompressArchiveInput(const char* input, size_t inputSize, std::string_view expectedEntryName, std::vector<char>& output)
{
	struct ArchiveDeleter {
		void operator()(struct archive* archive) const { archive_read_free(archive); }
	};
	std::unique_ptr<struct archive, ArchiveDeleter> archive{archive_read_new()};
	if (!archive) {
		return false;
	}

	archive_read_support_filter_all(archive.get());
	archive_read_support_format_zip(archive.get());
	archive_read_support_format_rar(archive.get());
	archive_read_support_format_rar5(archive.get());
	archive_read_support_format_7zip(archive.get());
	archive_read_support_format_raw(archive.get());
	if (archive_read_open_memory(archive.get(), input, inputSize) != ARCHIVE_OK) {
		return false;
	}

	bool foundOtbm = false;
	struct archive_entry* entry = nullptr;
	int status = ARCHIVE_OK;
	while ((status = archive_read_next_header(archive.get(), &entry)) == ARCHIVE_OK) {
		if (archive_entry_is_encrypted(entry) > 0) {
			return false;
		}

		const bool rawStream = (archive_format(archive.get()) & ARCHIVE_FORMAT_BASE_MASK) == ARCHIVE_FORMAT_RAW;
		if (archive_entry_filetype(entry) != AE_IFREG || (!rawStream && !matchesArchiveMapEntry(archive_entry_pathname(entry), expectedEntryName))) {
			if (archive_read_data_skip(archive.get()) != ARCHIVE_OK) {
				return false;
			}
			continue;
		}
		if (foundOtbm || archive_entry_size(entry) > static_cast<la_int64_t>(MAX_DECOMPRESSED_OTB_SIZE)) {
			return false;
		}

		foundOtbm = true;
		if (!readArchiveEntry(archive.get(), output)) {
			return false;
		}
	}

	return status == ARCHIVE_EOF && foundOtbm && archive_read_has_encrypted_entries(archive.get()) <= 0;
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
	compressedInput = isGzipInput(data, size) || isArchiveInput(data, size);
	if (compressedInput) {
		if (!allowCompressed) {
			throw CompressedOTBFormat{};
		}
		const std::string expectedEntryName = std::filesystem::path(fileName).stem().filename().string();
		const bool decompressed = isGzipInput(data, size) ? decompressGzipInput(data, size, decompressedContents)
		                                                  : decompressArchiveInput(data, size, expectedEntryName, decompressedContents);
		if (!decompressed) {
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
