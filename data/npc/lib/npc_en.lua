-- Falas dos NPCs escritas em portugues -> ingles (jogador com client em ingles).
-- Gerado em 06/11/2026 a partir das falas dos NPCs (data/npc/*.xml, data/npc/scripts/*.lua, data/npc/lib).
-- Pode editar a mao. Chave = texto ORIGINAL exato (como esta no XML/script, antes de trocar as tags).
-- |PLAYERNAME|, |ITEMNAME|, |ITEMCOUNT|, |TOTALCOST|... e $1..$9 (pedacos montados no script) sao
-- preservados/repostos. So caracteres Latin-1 nas traducoes (ver data/npc/lib/npc_lang.lua).

-- Textos mistos (Bager, Bashira, addon doll)
NpcLang.add("en", {
	["Ola |PLAYERNAME|. Hungry?"] = "Hello |PLAYERNAME|. Hungry?",
	["Hello |PLAYERNAME|. Eu vendo potions e runes."] = "Hello |PLAYERNAME|. I sell potions and runes.",
	["Hello |PLAYERNAME|.eu vendo Addon doll."] = "Hello |PLAYERNAME|. I sell the Addon doll.",
})

-- Eremo
NpcLang.add("en", {
	["Ola |PLAYERNAME|. Eu vendo a AOL mais barata do servidor, diga {trade}."] = "Hello |PLAYERNAME|. I sell the cheapest AOL on the server, say {trade}.",
})

-- Capitao.xml / scripts/barco.lua (sem spawn)
NpcLang.add("en", {
	["Bem vindo a Bordo, Sir |PLAYERNAME|. Para onde Voce quer ir?"] = "Welcome aboard, Sir |PLAYERNAME|. Where do you want to go?",
	["Tchau. Recomende-nos se você estivesse satisfeito com nosso serviço."] = "Good bye. Recommend us if you were satisfied with our service.",
	["Voce quer viajar para $1 por 5k?"] = "Do you want to travel to $1 for 5k?",
	["Voce quer viajar para kypros for 100 por 5k?"] = "Do you want to travel to kypros for 5k?",
	["Então fica aqui!"] = "Then stay here!",
})

-- capitao vip.xml / scripts/barcovip.lua (sem spawn)
NpcLang.add("en", {
	["Ola |PLAYERNAME|, gostaria de {viajar}?"] = "Hello |PLAYERNAME|, would you like to {travel}?",
	["Então, para viajar diga {yes}! Para isso, você deve ser vip!"] = "So, to travel say {yes}! You must be VIP for that!",
	["Certo. Para onde você deseja ir? Para {artemisias} ou a {ilha}?"] = "Alright. Where do you want to go? To {artemisias} or to the {island}?",
	["Você não é vip, vá embora!"] = "You are not VIP, go away!",
	["Tudo bem então..."] = "Alright then...",
	["Boa viagem!"] = "Have a nice trip!",
})

-- Lord of Vocation (XML + scripts/lord_of_vocation.lua + lib/functions/vocation_tiers.lua)
NpcLang.add("en", {
	["Ola |PLAYERNAME|. Eu comando a escada das vocacoes: Vocacao Suprema (level 150), Supreme (350) e Godly (400). Diga {vocacao} para saber o seu proximo passo."] = "Hello |PLAYERNAME|. I rule the vocation ladder: Vocacao Suprema (level 150), Supreme (350) and Godly (400). Say {vocation} to learn your next step.",
	["Ate logo, |PLAYERNAME|."] = "Good bye, |PLAYERNAME|.",
	["Feito! Use seus novos poderes com sabedoria."] = "Done! Use your new powers wisely.",
	["Volte quando estiver pronto."] = "Come back when you are ready.",
	["Sua vocacao nao participa da escada de tiers."] = "Your vocation is not part of the tier ladder.",
	["Voce ja esta no tier maximo ($1)."] = "You are already at the highest tier ($1).",
	["Primeiro faca a promocao normal (!promotion) para virar $1. Depois volte aqui."] = "First get the normal promotion (!promotion) to become $1. Then come back here.",
	["Voce pode virar $1 ($2). Requisitos: $3. Deseja subir agora? {yes}"] = "You can become $1 ($2). Requirements: $3. Do you want to advance now? {yes}",
	["Use !promotion para a promocao normal."] = "Use !promotion for the normal promotion.",
	["Voce precisa de level $1 para virar $2 (voce tem $3)."] = "You need level $1 to become $2 (you have $3).",
	["Voce precisa de $1x $2."] = "You need $1x $2.",
	["Voce precisa de $1 (inventario + banco)."] = "You need $1 (inventory + bank).",
	["Nao foi possivel cobrar o valor."] = "The payment could not be charged.",
	["Promocao"] = "Promotion",
})

-- Minerador / Anciao dos Mineradores (XML + scripts/minerador.lua, troca.lua)
NpcLang.add("en", {
	["Ola |PLAYERNAME|! Não sabe pra que serve este lugar? Diga {ajuda}. Eu tambem vendo Picareta, diga {trade}."] = "Hello |PLAYERNAME|! Don't know what this place is for? Say {help}. I also sell pickaxes, say {trade}.",
	["Seja bem vindo |PLAYERNAME|! Não sabe pra que serve este lugar? Diga {ajuda}. Eu tambem vendo Picareta, diga {trade}."] = "Welcome, |PLAYERNAME|! Don't know what this place is for? Say {help}. I also sell pickaxes, say {trade}.",
	["Este lugar é uma mina, para minerar você deve comprar uma {picareta} comigo. Para minerar você deve usar a {picareta} nas rochas. Mineirando voce ganhara nuggets, que podera ser trocado por nucleos no {Anciao}."] = "This place is a mine. To mine you must buy a {pickaxe} from me and use the {pickaxe} on the rocks. Mining gives you nuggets, which can be exchanged for cores with the {Elder}.",
	["Para comprar a picareta diga {trade}"] = "To buy the pickaxe say {trade}",
	["O Anciao Dos Mineradores, esta aqui perto, ele troca nuggets por nucleos."] = "The Elder of the Miners is close by; he exchanges nuggets for cores.",
	["Até logo, se estiver com duvida volte a falar comigo."] = "Good bye. If you have any questions, come talk to me again.",
	["Posso ajudar?"] = "Can I help you?",
	["Ola, eu troco 500 nuggets por um {nucleo medio}, ou 1000 nuggets por um {nucleo altissimo}."] = "Hello, I exchange 500 nuggets for a {medium core}, or 1000 nuggets for a {highest core}.",
	["Voce prescisa de 500 gold nuggets para ganhar um nucleo medio."] = "You need 500 gold nuggets to get a medium core.",
	["Voce prescisa de 1000 gold nuggets para ganhar um nucleo altissimo."] = "You need 1000 gold nuggets to get a highest core.",
})

-- Pbot Rox King (ajuda.xml, sem spawn)
NpcLang.add("en", {
	["|PLAYERNAME|, seja bem vindo ao Pbot Rox! Para saber sobre o servidor diga {ajuda}. Eu tambem vendo Aol, diga {trade}."] = "|PLAYERNAME|, welcome to Pbot Rox! To learn about the server say {help}. I also sell AOL, say {trade}.",
	["Para saber sobre o servidor diga {ajuda}. Eu tambem vendo Aol, diga {trade}."] = "To learn about the server say {help}. I also sell AOL, say {trade}.",
	["Deseja saber sobre {mapa}, {voc suprem}, {report bug} ou {noticias}?"] = "Do you want to know about the {map}, {voc suprem}, {report bug} or {news}?",
	["O mapa tem 7 cidades. Artemisias, Egeu, Kypros, Horpus, Nissea, Valentia e Styge. Pode-se acessalas atraves do barco."] = "The map has 7 cities: Artemisias, Egeu, Kypros, Horpus, Nissea, Valentia and Styge. You can reach them by boat.",
	["Para Obter uma Vocacao Suprema você deve comprar no site, ou realizar a quest."] = "To get a Vocacao Suprema you must buy it on the website or complete the quest.",
	["Para Reportar um Bug, ou para realizar duvidas, você podera usar o forum do site."] = "To report a bug or ask questions, use the forum on the website.",
	["Tchau."] = "Bye.",
	["Para Saber as noticias basta ficar de olho no site, aguarde as atualizacoes que estão por vir."] = "To follow the news just keep an eye on the website; stay tuned for the upcoming updates.",
})

-- trocas parciais (padroes Lua) para pedacos montados por concatenacao
NpcLang.addFragments("en", {
	{"RESET para o level (%d+) %(skills e magic level ficam%)", "RESET to level %1 (skills and magic level are kept)"},
})
