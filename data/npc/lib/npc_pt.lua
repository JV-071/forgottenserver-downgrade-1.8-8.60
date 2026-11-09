-- Falas dos NPCs em portugues (jogador com client em portugues).
-- Gerado em 06/11/2026 a partir das falas dos NPCs (data/npc/*.xml, data/npc/scripts/*.lua, data/npc/lib).
-- Pode editar a mao. Chave = texto ORIGINAL exato (como esta no XML/script, antes de trocar as tags).
-- |PLAYERNAME|, |ITEMNAME|, |ITEMCOUNT|, |TOTALCOST|... e $1..$9 (pedacos montados no script) sao
-- preservados/repostos. So caracteres Latin-1 nas traducoes (ver data/npc/lib/npc_lang.lua).

-- NpcHandler (npcsystem) - mensagens padrao
NpcLang.add("pt", {
	-- Rosaria (06/11/2026)
	["Hello |PLAYERNAME|. I sell flowers, {trade} with me."] = "Olá |PLAYERNAME|. Eu vendo flores, quer {negociar} comigo?",
	["Good bye, |PLAYERNAME|. Come back for more flowers!"] = "Até logo, |PLAYERNAME|. Volte para comprar mais flores!",
	["Greetings, |PLAYERNAME|."] = "Saudações, |PLAYERNAME|.",
	["Good bye, |PLAYERNAME|."] = "Até logo, |PLAYERNAME|.",
	["Do you want to buy |ITEMCOUNT| |ITEMNAME| for |TOTALCOST| gold coins?"] = "Você quer comprar |ITEMCOUNT| |ITEMNAME| por |TOTALCOST| gold coins?",
	["Here you are."] = "Aqui está.",
	["Bought |ITEMCOUNT|x |ITEMNAME| for |TOTALCOST| gold."] = "Comprou |ITEMCOUNT|x |ITEMNAME| por |TOTALCOST| gold.",
	["Do you want to sell |ITEMCOUNT| |ITEMNAME| for |TOTALCOST| gold coins?"] = "Você quer vender |ITEMCOUNT| |ITEMNAME| por |TOTALCOST| gold coins?",
	["Here you are, |TOTALCOST| gold."] = "Aqui está, |TOTALCOST| gold.",
	["Sold |ITEMCOUNT|x |ITEMNAME| for |TOTALCOST| gold."] = "Vendeu |ITEMCOUNT|x |ITEMNAME| por |TOTALCOST| gold.",
	["You don't have enough money."] = "Você não tem dinheiro suficiente.",
	["You don't have so many."] = "Você não tem tantos.",
	["You do not have this object."] = "Você não tem esse objeto.",
	["You do not have enough capacity."] = "Você não tem capacidade suficiente.",
	["You do not have enough capacity for all items."] = "Você não tem capacidade suficiente para todos os itens.",
	["Good bye."] = "Até logo.",
	["Then not."] = "Então não.",
	["Of course, just browse through my wares."] = "Claro, fique à vontade para ver as minhas mercadorias.",
	["Sorry, I'm not offering anything."] = "Desculpe, não estou oferecendo nada.",
	["Thank you, come back whenever you're in need of something else."] = "Obrigado, volte sempre que precisar de mais alguma coisa.",
	["|PLAYERNAME|, I am already talking to you."] = "|PLAYERNAME|, eu já estou falando com você.",
	["Please wait before buying again."] = "Aguarde um pouco antes de comprar de novo.",
})

-- StdModule / TravelModule (npcsystem/modules.lua)
NpcLang.add("pt", {
	["You are already promoted!"] = "Você já é promovido!",
	["I am sorry, but I can only promote you once you have reached level $1."] = "Desculpe, mas só posso te promover quando você atingir o level $1.",
	["You do not have enough money!"] = "Você não tem dinheiro suficiente!",
	["You need a premium account in order to get promoted."] = "Você precisa de uma conta premium para ser promovido.",
	["You already know this spell."] = "Você já conhece essa magia.",
	["You cannot learn this spell."] = "Você não pode aprender essa magia.",
	["You do not have enough money, this spell costs $1 gold."] = "Você não tem dinheiro suficiente, essa magia custa $1 gold.",
	["You have learned $1."] = "Você aprendeu $1.",
	["You need a premium account in order to buy $1."] = "Você precisa de uma conta premium para comprar $1.",
	["Gods have already blessed you with this blessing!"] = "Os deuses já te abençoaram com essa bênção!",
	["You don't have enough money for blessing."] = "Você não tem dinheiro suficiente para a bênção.",
	["You have been blessed by one of the five gods!"] = "Você foi abençoado por um dos cinco deuses!",
	["You need a premium account in order to be blessed."] = "Você precisa de uma conta premium para ser abençoado.",
	["First get rid of those blood stains! You are not going to ruin my vehicle!"] = "Primeiro limpe essas manchas de sangue! Você não vai estragar o meu veículo!",
	["You must reach level $1 before I can let you go there."] = "Você precisa atingir o level $1 antes que eu possa te deixar ir para lá.",
	["Set the sails!"] = "Içar as velas!",
	["I'm sorry, but you need a premium account in order to travel onboard our ships."] = "Desculpe, mas você precisa de uma conta premium para viajar nos nossos navios.",
	["Do you want to travel to $1 for $2 gold coins?"] = "Você quer viajar para $1 por $2 gold coins?",
	["Get out of there with this blood."] = "Saia daí com esse sangue.",
	["It was a pleasure doing business with you."] = "Foi um prazer fazer negócio com você.",
	["I can only allow premium players to travel there."] = "Só posso deixar jogadores premium viajarem para lá.",
})

-- revnpcsys (lua/*: Mad, Perac...) - constants.lua / shop.lua / events.lua
NpcLang.add("pt", {
	["You need more money"] = "Você precisa de mais dinheiro",
	["You bought |ITEMCOUNT| |ITEMNAME|(s) for |TOTALCOST| gold."] = "Você comprou |ITEMCOUNT| |ITEMNAME|(s) por |TOTALCOST| gold.",
	["You sold |ITEMCOUNT| |ITEMNAME|(s) for |TOTALCOST| gold."] = "Você vendeu |ITEMCOUNT| |ITEMNAME|(s) por |TOTALCOST| gold.",
	["You do not meet the storage requirement."] = "Você não cumpre o requisito necessário.",
	["You need to be exactly level |PLAYERLEVEL|."] = "Você precisa ter exatamente o level |PLAYERLEVEL|.",
	["You need to be higher then level |PLAYERLEVEL| and below |PLAYERLEVEL2|."] = "Você precisa estar acima do level |PLAYERLEVEL| e abaixo do level |PLAYERLEVEL2|.",
	["You need to be level |PLAYERLEVEL| or higher and below |PLAYERLEVEL2|."] = "Você precisa ter level |PLAYERLEVEL| ou mais e estar abaixo do level |PLAYERLEVEL2|.",
	["You need to be higher then level |PLAYERLEVEL| and below or equal |PLAYERLEVEL2|."] = "Você precisa estar acima do level |PLAYERLEVEL| e no máximo no level |PLAYERLEVEL2|.",
	["You need to be between level |PLAYERLEVEL| and |PLAYERLEVEL2|."] = "Você precisa estar entre o level |PLAYERLEVEL| e o |PLAYERLEVEL2|.",
	["You can't be exactly level |PLAYERLEVEL|."] = "Você não pode ter exatamente o level |PLAYERLEVEL|.",
	["You need to be atleast level |PLAYERLEVEL|."] = "Você precisa ter pelo menos o level |PLAYERLEVEL|.",
	["You need to be below level |PLAYERLEVEL|."] = "Você precisa estar abaixo do level |PLAYERLEVEL|.",
	["You need to be premium to do this."] = "Você precisa ser premium para fazer isso.",
	["You need to be a |VOCATIONNAME| to do this."] = "Você precisa ser |VOCATIONNAME| para fazer isso.",
	["You do not have enough money, it costs |TOTALCOST| gold."] = "Você não tem dinheiro suficiente, custa |TOTALCOST| gold.",
	["You do not have atleast |ITEMCOUNT| |ITEMNAME|(s)."] = "Você não tem pelo menos |ITEMCOUNT| |ITEMNAME|(s).",
	["You need to be in fight."] = "Você precisa estar em combate.",
	["You have to be out of fight."] = "Você precisa estar fora de combate.",
	["You need to be pz locked"] = "Você precisa estar com PZ bloqueado",
	["You are not allowed to be pz locked"] = "Você não pode estar com PZ bloqueado",
	["Hello |PLAYERNAME| how can I help you?"] = "Olá, |PLAYERNAME|, como posso te ajudar?",
	["Greetings |PLAYERNAME|, what can I do for you?"] = "Saudações, |PLAYERNAME|, o que posso fazer por você?",
	["Hi |PLAYERNAME|, what's your desire today?"] = "Oi, |PLAYERNAME|, o que você deseja hoje?",
	["Goodbye |PLAYERNAME|, have a nice day!"] = "Tchau, |PLAYERNAME|, tenha um bom dia!",
	["Farewell |PLAYERNAME|, see you soon!"] = "Adeus, |PLAYERNAME|, até breve!",
	["See you later |PLAYERNAME|, take care!"] = "Até mais, |PLAYERNAME|, se cuida!",
	["The items are to heavy for you to carry. I've sent them to your inbox."] = "Os itens estão pesados demais para você carregar. Mandei para a sua inbox.",
	["You don't have enough space in your backpack. I've sent the items to your inbox."] = "Você não tem espaço suficiente na backpack. Mandei os itens para a sua inbox.",
	["Your items are waiting for you in your inbox."] = "Os seus itens estão te esperando na sua inbox.",
	["Hello |PLAYERNAME| I can {travel} you to wherever you want, just tell me your {destination}"] = "Olá, |PLAYERNAME|, posso te levar para onde você quiser, é só me dizer o seu {destino}",
	["Farewell, |PLAYERNAME|!"] = "Adeus, |PLAYERNAME|!",
	["Hello |PLAYERNAME|. I sell bows and ammunition. Say {trade}!"] = "Olá, |PLAYERNAME|. Eu vendo arcos e munição. Diga {negociar}!",
	["Hello |PLAYERNAME|. I buy swords, clubs, axes, helmets, boots, legs, shields and armors. Say {trade}!"] = "Olá, |PLAYERNAME|. Eu compro espadas, clavas, machados, capacetes, botas, calças, escudos e armaduras. Diga {negociar}!",
	["Here is what I offer!"] = "Veja o que eu ofereço!",
})

-- Addoner / addon doll
NpcLang.add("pt", {
	["Hello |PLAYERNAME|. I am the Addoner: I sell the {addon doll} and I know everything about addon {tasks}. Just {trade}."] = "Olá, |PLAYERNAME|. Eu sou o Addoner: vendo a {addon doll} e sei tudo sobre as {tarefas} de addon. É só dizer {negociar}.",
	["Good bye, |PLAYERNAME|. Come back with your addons!"] = "Até logo, |PLAYERNAME|. Volte com os seus addons!",
	["Good bye then."] = "Até logo, então.",
	["I deliver addons. I sell the {addon doll} and, soon, I will give addon {tasks} to players of level 100 or more."] = "Eu entrego addons. Vendo a {addon doll} e, em breve, vou dar {tarefas} de addon para jogadores de level 100 ou mais.",
	["I am the Addoner."] = "Eu sou o Addoner.",
	["Addon tasks (kill X monsters and bring Y items for an addon) are still under construction. For now, buy an {addon doll} with {trade}."] = "As tarefas de addon (matar X monstros e trazer Y itens em troca de um addon) ainda estão em construção. Por enquanto, compre uma {addon doll} com {negociar}.",
	["The addon doll gives you an addon of your choice. It costs 1000000 gold coins, just {trade}."] = "A addon doll te dá um addon à sua escolha. Custa 1000000 gold coins, é só dizer {negociar}.",
	["Hello |PLAYERNAME|.eu vendo Addon doll."] = "Olá, |PLAYERNAME|. Eu vendo a Addon doll.",
})

-- Angel Statue
NpcLang.add("pt", {
	["A voice echoes in your mind, |PLAYERNAME|... Ask the statue about its {mission}, its {name} or its {job}."] = "Uma voz ecoa em sua mente, |PLAYERNAME|... Pergunte à estátua sobre a sua {missão}, o seu {nome} ou o seu {trabalho}.",
	["May the light guide you, |PLAYERNAME|."] = "Que a luz te guie, |PLAYERNAME|.",
	["May the light guide you."] = "Que a luz te guie.",
	["I am the Angel Statue of the temple of Artemisias."] = "Eu sou a Angel Statue do templo de Artemisias.",
	["I grant a special mission to heroes of level 100. The mission is still being prepared."] = "Eu concedo uma missão especial aos heróis de level 100. A missão ainda está sendo preparada.",
	["The mission for heroes of level 100 is under construction. Come back later and you will receive a reward according to your vocation."] = "A missão para heróis de level 100 está em construção. Volte mais tarde e você receberá uma recompensa de acordo com a sua vocação.",
	["Each vocation receives its own reward when the mission is complete. Not yet, hero."] = "Cada vocação recebe a sua própria recompensa quando a missão estiver completa. Ainda não, herói.",
})

-- Bager / Bashira / Donald / Eremo / Frodo / Decoration Seller
NpcLang.add("pt", {
	["Ola |PLAYERNAME|. Hungry?"] = "Olá, |PLAYERNAME|. Com fome?",
	["Hello |PLAYERNAME|. Eu vendo potions e runes."] = "Olá, |PLAYERNAME|. Eu vendo potions e runas.",
	["You do not have enough money."] = "Você não tem dinheiro suficiente.",
	["Is |TOTALCOST| gold coins too much for you?"] = "|TOTALCOST| gold coins é muito para você?",
	["Hello |PLAYERNAME|. I sell ham, meat, carrots, apples, brown breads, brown mushrooms and eggs (everything for 8 gold coins)!"] = "Olá, |PLAYERNAME|. Eu vendo ham, meat, carrots, apples, brown breads, brown mushrooms e eggs (tudo por 8 gold coins)!",
	["Ola |PLAYERNAME|. Eu vendo a AOL mais barata do servidor, diga {trade}."] = "Olá, |PLAYERNAME|. Eu vendo a AOL mais barata do servidor, diga {negociar}.",
	["Hello |PLAYERNAME|. I sell ropes (50gp), shovels (20gp), backpacks (10gp), fishing rods (100gp), and torches (2gp). I buy vials (10gp)."] = "Olá, |PLAYERNAME|. Eu vendo ropes (50gp), shovels (20gp), backpacks (10gp), fishing rods (100gp) e torches (2gp). Eu compro vials (10gp).",
	["Hello |PLAYERNAME|. I sell chairs, tables, plants, containers, pillows, tapestries and more. Everything for 500 gold pieces."] = "Olá, |PLAYERNAME|. Eu vendo cadeiras, mesas, plantas, baús, almofadas, tapeçarias e muito mais. Tudo por 500 gold pieces.",
})

-- Bashira (scripts/malak_runes.lua)
NpcLang.add("pt", {
	["So you ask me for a {$1} to begin your advanture?"] = "Então você me pede uma {$1} para começar a sua aventura?",
	["What? I have already gave you one {$1}!"] = "O quê? Eu já te dei uma {$1}!",
	["Sorry, you aren't a druid either a sorcerer."] = "Desculpe, você não é druid nem sorcerer.",
	["Here you are young adept, take care yourself."] = "Aqui está, jovem adepto. Cuide-se.",
	["Ok then."] = "Tudo bem, então.",
})

-- Capitaes (Captain Max*, Captain Of *, scripts/captain_styller.lua)
NpcLang.add("pt", {
	["Welcome aboard, |PLAYERNAME|! I am the captain of $1. Say {travel} to see the cities I can sail you to, or just name the city you want."] = "Bem-vindo a bordo, |PLAYERNAME|! Eu sou o capitão de $1. Diga {viajar} para ver as cidades para onde posso te levar, ou diga o nome da cidade que você quer.",
	["Welcome aboard, |PLAYERNAME|! Say {travel} to see the cities I can sail you to, or just name the city you want."] = "Bem-vindo a bordo, |PLAYERNAME|! Diga {viajar} para ver as cidades para onde posso te levar, ou diga o nome da cidade que você quer.",
	["Good bye, |PLAYERNAME|. Recommend us if you were satisfied with our service."] = "Até logo, |PLAYERNAME|. Recomende-nos se você ficou satisfeito com o nosso serviço.",
	["First get rid of those blood stains! You are not going to ruin my ship!"] = "Primeiro limpe essas manchas de sangue! Você não vai estragar o meu navio!",
	["You don't have enough money. The passage to $1 costs $2 gold coins."] = "Você não tem dinheiro suficiente. A passagem para $1 custa $2 gold coins.",
	["Then stay here, if you like."] = "Então fique aqui, se preferir.",
	["I can sail you to $1. Where do you want to go?"] = "Posso te levar para $1. Para onde você quer ir?",
	["I am the captain of this ship. Say {travel} and I will tell you where we can sail."] = "Eu sou o capitão deste navio. Diga {viajar} e eu te digo para onde podemos navegar.",
	["I am $1, at your service."] = "Eu sou $1, ao seu dispor.",
	["the captain"] = "o capitão",
	["You are already in $1! Say {travel} to see the other cities."] = "Você já está em $1! Diga {viajar} para ver as outras cidades.",
	["Do you want to sail to $1 for $2 gold coins? {yes} or {no}"] = "Você quer navegar para $1 por $2 gold coins? {sim} ou {não}",
	["I can take you to Cidade."] = "Posso te levar para a Cidade.",
	["I am the captain of this ship."] = "Eu sou o capitão deste navio.",
	["I can only take you to Cidade."] = "Só posso te levar para a Cidade.",
	["Então, para viajar diga {yes}! Para isso, você deve ser vip!"] = "Então, para viajar diga {sim}! Para isso, você deve ser vip!",
})

-- Gandalf
NpcLang.add("pt", {
	["Hello |PLAYERNAME|. I sell bags and backpacks of every colour: bag (10 gp), backpack (20 gp), coloured backpacks (50 gp), fur backpack (100 gp), beach, pirate and camouflage backpacks (150 gp) and the jewelled backpack (500 gp). Just {trade}."] = "Olá, |PLAYERNAME|. Eu vendo bags e backpacks de todas as cores: bag (10 gp), backpack (20 gp), backpacks coloridas (50 gp), fur backpack (100 gp), backpacks beach, pirate e camouflage (150 gp) e a jewelled backpack (500 gp). É só dizer {negociar}.",
	["Good bye, |PLAYERNAME|. Do not lose your backpack!"] = "Até logo, |PLAYERNAME|. Não perca a sua backpack!",
	["I am a wandering wizard, but these days I only sell backpacks. Just {trade}."] = "Sou um mago andarilho, mas hoje em dia só vendo backpacks. É só dizer {negociar}.",
	["I am Gandalf, the backpack dealer."] = "Eu sou Gandalf, o vendedor de backpacks.",
	["Bags, backpacks, coloured backpacks, fur, beach, pirate, camouflage and jewelled backpacks. Just {trade}."] = "Bags, backpacks, backpacks coloridas e backpacks fur, beach, pirate, camouflage e jewelled. É só dizer {negociar}.",
})

-- Guard Of The Mansion
NpcLang.add("pt", {
	["Halt, |PLAYERNAME|! This is the mansion. State your business: ask my {name} or my {job}."] = "Alto lá, |PLAYERNAME|! Esta é a mansão. Diga o que deseja: pergunte o meu {nome} ou o meu {trabalho}.",
	["Move along, |PLAYERNAME|."] = "Circulando, |PLAYERNAME|.",
	["Move along."] = "Circulando.",
	["I am the Guard of the Mansion. That is all you need to know."] = "Eu sou o Guard of the Mansion. É tudo o que você precisa saber.",
	["I guard this mansion day and night. Nobody enters without permission."] = "Eu guardo esta mansão dia e noite. Ninguém entra sem permissão.",
	["The mansion belongs to a very important person. Do not touch anything."] = "A mansão pertence a uma pessoa muito importante. Não toque em nada.",
	["The owner does not receive visitors. Move along."] = "O dono não recebe visitas. Circulando.",
})

-- Harlow Vengoth
NpcLang.add("pt", {
	["Welcome to my humble lands, |PLAYERNAME|. Few mortals come here... ask about my {name} or {job} if you dare."] = "Bem-vindo às minhas humildes terras, |PLAYERNAME|. Poucos mortais vêm até aqui... pergunte sobre o meu {nome} ou o meu {trabalho}, se tiver coragem.",
	["Farewell, |PLAYERNAME|. Do not stay out after dark."] = "Adeus, |PLAYERNAME|. Não fique na rua depois que escurecer.",
	["Leaving so soon?"] = "Já vai tão cedo?",
	["I am Harlow, of the house of Vengoth."] = "Eu sou Harlow, da casa de Vengoth.",
	["I watch over these lands and over the ones who come here at night. I have nothing to sell you... yet."] = "Eu vigio estas terras e aqueles que chegam aqui à noite. Não tenho nada para te vender... ainda.",
	["Vengoth is the land of my family. The mists hide more than you think."] = "Vengoth é a terra da minha família. As névoas escondem mais do que você imagina.",
	["Vampires? Rumours. Only rumours, mortal."] = "Vampiros? Boatos. Apenas boatos, mortal.",
})

-- Item Dealer
NpcLang.add("pt", {
	["Greetings |PLAYERNAME|. I am the Item Dealer. Ask me about {loot medals} or my {job}."] = "Saudações, |PLAYERNAME|. Eu sou o Item Dealer. Pergunte-me sobre as {medalhas de loot} ou o meu {trabalho}.",
	["Good bye, |PLAYERNAME|. Come back when the medals are ready."] = "Até logo, |PLAYERNAME|. Volte quando as medalhas estiverem prontas.",
	["I buy loot from hunters. With a {loot medal} I will pay 10 percent more than the other merchants. That service is still under construction."] = "Eu compro o loot dos caçadores. Com uma {medalha de loot} eu pago 10 por cento a mais que os outros mercadores. Esse serviço ainda está em construção.",
	["I am the Item Dealer."] = "Eu sou o Item Dealer.",
	["Item Dealer: loot medal exchange is under construction. Soon you will sell your loot here for 10 percent more if you carry a Medal of Honour."] = "Item Dealer: a troca por medalhas de loot está em construção. Em breve você poderá vender o seu loot aqui por 10 por cento a mais se tiver uma Medal of Honour.",
	["My loot shop is under construction. Come back later!"] = "A minha loja de loot está em construção. Volte mais tarde!",
})

-- Lola (XML + scripts/lola.lua)
NpcLang.add("pt", {
	["Hello |PLAYERNAME|. I sell {chairs}, {tables}, {furniture}, {pillows}, {tapestries}, {mirrors}, {beds} and {more}. Everything for 500 gold pieces, just {trade}."] = "Olá, |PLAYERNAME|. Eu vendo {cadeiras}, {mesas}, {móveis}, {almofadas}, {tapeçarias}, {espelhos}, {camas} e {outros}. Tudo por 500 gold pieces, é só dizer {negociar}.",
	["I sell wooden, sofa, red cushioned, green cushioned, tusk, ivory, rocking and trunk chairs. Just {trade}."] = "Eu vendo cadeiras wooden, sofa, red cushioned, green cushioned, tusk, ivory, rocking e trunk. É só dizer {negociar}.",
	["I sell big, square, round, small, stone, tusk, bamboo and trunk tables. Just {trade}."] = "Eu vendo mesas big, square, round, small, stone, tusk, bamboo e trunk. É só dizer {negociar}.",
	["I sell trunks, drawers, dressers, lockers, troughs, barrels, bookcases and racks for armors and weapons. Just {trade}."] = "Eu vendo baús, gaveteiros, cômodas, armários, cochos, barris, estantes e suportes para armaduras e armas. É só dizer {negociar}.",
	["I sell coal basins, birdcages, harps, pianos, globes, clocks, lamps, telescopes, statues and plants. Just {trade}."] = "Eu vendo braseiros, gaiolas, harpas, pianos, globos, relógios, luminárias, telescópios, estátuas e plantas. É só dizer {negociar}.",
	["I sell purple, green, yellow, orange, red, blue and white tapestries. Just {trade}."] = "Eu vendo tapeçarias roxas, verdes, amarelas, laranjas, vermelhas, azuis e brancas. É só dizer {negociar}.",
	["I sell heart, {small}, {square} and {round} pillows. Just {trade}."] = "Eu vendo almofadas de coração, {pequenas}, {quadradas} e {redondas}. É só dizer {negociar}.",
	["I sell small purple, small green, small red, small blue, small orange, small turquoise and small white pillows."] = "Eu vendo almofadas pequenas roxas, verdes, vermelhas, azuis, laranjas, turquesa e brancas.",
	["I sell round blue, round red, round purple and round turquoise pillows."] = "Eu vendo almofadas redondas azuis, vermelhas, roxas e turquesa.",
	["I sell blue, red, green and yellow pillows."] = "Eu vendo almofadas quadradas azuis, vermelhas, verdes e amarelas.",
	["I sell wall mirrors and standing mirrors for 750 gold pieces. Just {trade}."] = "Eu vendo espelhos de parede e espelhos de chão por 750 gold pieces. É só dizer {negociar}.",
	["I sell green, yellow, red and blue bed kits for 1000 gold pieces each. Just {trade}."] = "Eu vendo kits de cama verdes, amarelos, vermelhos e azuis por 1000 gold pieces cada. É só dizer {negociar}.",
	["I sell everything you need to decorate your house. Just {trade}."] = "Eu vendo tudo o que você precisa para decorar a sua casa. É só dizer {negociar}.",
	["My name is Lola."] = "Meu nome é Lola.",
})

-- Lord of Vocation (original em portugues, so {yes} -> {sim})
NpcLang.add("pt", {
	["Voce pode virar $1 ($2). Requisitos: $3. Deseja subir agora? {yes}"] = "Você pode virar $1 ($2). Requisitos: $3. Deseja subir agora? {sim}",
})

-- Madira / Maia / Maiad (XML + scripts/loot2-4.lua) e scripts/addon doll.lua
NpcLang.add("pt", {
	["Hello |PLAYERNAME|. I buy swords, clubs, axes, helmets, boots, legs, shields and armors."] = "Olá, |PLAYERNAME|. Eu compro espadas, clavas, machados, capacetes, botas, calças, escudos e armaduras.",
	["I buy royal (40k), warrior (6k), crusader (9k), crown (5k), devil (4k), chain (35gp) and iron helmets (30gp), also mystic turbans (500gp)."] = "Eu compro os capacetes royal (40k), warrior (6k), crusader (9k), crown (5k), devil (4k), chain (35gp) e iron (30gp), e também mystic turbans (500gp).",
	["I buy golden boots (100k), steel boots (40k) and boots of haste (40k)."] = "Eu compro golden boots (100k), steel boots (40k) e boots of haste (40k).",
	["I buy golden (30k), crown (20k), knight (5k), lady (7,5k), plate (400gp), brass (200gp) and chain armors (100gp), also mpa (100k), dsm (60k) and blue robes (15k)."] = "Eu compro as armaduras golden (30k), crown (20k), knight (5k), lady (7,5k), plate (400gp), brass (200gp) e chain (100gp), e também mpa (100k), dsm (60k) e blue robes (15k).",
	["I buy golden (80k), crown (15k), knight (6k), plate (500gp) and brass legs (100gp)."] = "Eu compro as legs golden (80k), crown (15k), knight (6k), plate (500gp) e brass (100gp).",
	["I buy blessed (150k), great (100k), demon (40k), vampire (25k), medusa (8k), amazon (4k), crown (5k), tower (4k), dragon (3k), guardian (2k), beholder (1k), and dwarven shields (100gp), also mms (80k)."] = "Eu compro os escudos blessed (150k), great (100k), demon (40k), vampire (25k), medusa (8k), amazon (4k), crown (5k), tower (4k), dragon (3k), guardian (2k), beholder (1k) e dwarven (100gp), e também mms (80k).",
	["I buy giant (10k), bright (6k), fire (3k) serpent (1.5k), spike (800gp) and two handed swords (400gp), also ice rapiers (4k), magic longswords (150k), magic swords (90k), warlord swords (100k) broad swords (70gp), short swords (30gp), sabres (25gp) and swords (25gp)."] = "Eu compro as espadas giant (10k), bright (6k), fire (3k), serpent (1.5k), spike (800gp) e two handed (400gp), e também ice rapiers (4k), magic longswords (150k), magic swords (90k), warlord swords (100k), broad swords (70gp), short swords (30gp), sabres (25gp) e swords (25gp).",
	["I buy fire (10k), guardian halberds (7,5k) knight (2k), double (200gp) and battle axes (100gp), also dragon lances (10k), stonecutters axes (90k), halberds (200gp) and hatchets (20gp)."] = "Eu compro os machados fire (10k), knight (2k), double (200gp) e battle (100gp), e também guardian halberds (7,5k), dragon lances (10k), stonecutter axes (90k), halberds (200gp) e hatchets (20gp).",
	["I buy thunder hammers (90k), war (6k), dragon (2k) and battle hammers (60gp), also skull staffs (10k) and clerical maces (200gp)."] = "Eu compro os martelos thunder (90k), war (6k), dragon (2k) e battle (60gp), e também skull staffs (10k) e clerical maces (200gp).",
})

-- Minerador / Pbot Rox King (originais em portugues, so {trade} -> {negociar})
NpcLang.add("pt", {
	["Ola |PLAYERNAME|! Não sabe pra que serve este lugar? Diga {ajuda}. Eu tambem vendo Picareta, diga {trade}."] = "Olá, |PLAYERNAME|! Não sabe para que serve este lugar? Diga {ajuda}. Eu também vendo Picareta, diga {negociar}.",
	["Seja bem vindo |PLAYERNAME|! Não sabe pra que serve este lugar? Diga {ajuda}. Eu tambem vendo Picareta, diga {trade}."] = "Seja bem-vindo, |PLAYERNAME|! Não sabe para que serve este lugar? Diga {ajuda}. Eu também vendo Picareta, diga {negociar}.",
	["Para comprar a picareta diga {trade}"] = "Para comprar a picareta diga {negociar}",
	["|PLAYERNAME|, seja bem vindo ao Pbot Rox! Para saber sobre o servidor diga {ajuda}. Eu tambem vendo Aol, diga {trade}."] = "|PLAYERNAME|, seja bem-vindo ao Pbot Rox! Para saber sobre o servidor diga {ajuda}. Eu também vendo Aol, diga {negociar}.",
	["Para saber sobre o servidor diga {ajuda}. Eu tambem vendo Aol, diga {trade}."] = "Para saber sobre o servidor diga {ajuda}. Eu também vendo Aol, diga {negociar}.",
})

-- Xangretor / Zurak
NpcLang.add("pt", {
	["So you climbed all the way up here, |PLAYERNAME|. Ask my {name} or my {job}, then go back down."] = "Então você subiu até aqui em cima, |PLAYERNAME|. Pergunte o meu {nome} ou o meu {trabalho} e depois desça de volta.",
	["Farewell, |PLAYERNAME|. Mind the fall."] = "Adeus, |PLAYERNAME|. Cuidado com a queda.",
	["Farewell then."] = "Adeus, então.",
	["I am Xangretor, keeper of this high place."] = "Eu sou Xangretor, guardião deste lugar alto.",
	["I guard old secrets. None that concern you, for now."] = "Eu guardo segredos antigos. Nenhum que te diga respeito, por enquanto.",
	["This place is older than any city below. Respect it."] = "Este lugar é mais antigo que qualquer cidade lá embaixo. Respeite-o.",
	["Hmpf. A visitor, |PLAYERNAME|. Speak quickly: ask my {name} or my {job} and leave."] = "Hmpf. Um visitante, |PLAYERNAME|. Fale rápido: pergunte o meu {nome} ou o meu {trabalho} e vá embora.",
	["Go, |PLAYERNAME|. The shadows are watching."] = "Vá, |PLAYERNAME|. As sombras estão observando.",
	["Rude mortal."] = "Mortal mal-educado.",
	["I am Zurak. Remember the name."] = "Eu sou Zurak. Lembre-se deste nome.",
	["I study the dark arts. I have no business with you for now."] = "Eu estudo as artes sombrias. Não tenho nada a tratar com você por enquanto.",
	["The shadows keep my secrets. Come back when you are stronger."] = "As sombras guardam os meus segredos. Volte quando estiver mais forte.",
})

-- Entrada: palavras em portugues -> keyword em ingles (NpcHandler anexa; revnpcsys troca a mensagem inteira)
NpcLang.addAliases({
	{"oi", "hi"},
	{"ola", "hi"},
	{"oie", "hi"},
	{"opa", "hi"},
	{"eae", "hi"},
	{"eai", "hi"},
	{"salve", "hi"},
	{"bom dia", "hi"},
	{"boa tarde", "hi"},
	{"boa noite", "hi"},
	{"tchau", "bye"},
	{"xau", "bye"},
	{"adeus", "bye"},
	{"ate logo", "bye"},
	{"ate mais", "bye"},
	{"ate breve", "bye"},
	{"falou", "bye"},
	{"flw", "bye"},
	{"sim", "yes"},
	{"claro", "yes"},
	{"nao", "no"},
	{"negociar", "trade"},
	{"trocar", "trade"},
	{"troca", "trade"},
	{"comprar", "trade"},
	{"vender", "trade"},
	{"comerciar", "trade"},
	{"loja", "trade"},
	{"ofertas", "trade"},
	{"ajuda", "help"},
	{"nome", "name"},
	{"trabalho", "job"},
	{"profissao", "job"},
	{"emprego", "job"},
	{"ocupacao", "job"},
	{"missao", "mission"},
	{"missoes", "missions"},
	{"tarefa", "task"},
	{"tarefas", "tasks"},
	{"recompensa", "reward"},
	{"premio", "reward"},
	{"viajar", "travel"},
	{"viagem", "travel"},
	{"navegar", "sail"},
	{"destino", "destination"},
	{"passagem", "passage"},
	{"cidade", "city"},
	{"cidades", "cities"},
	{"boneca", "doll"},
	{"boneco", "doll"},
	{"medalha", "medal"},
	{"medalhas", "medals"},
	{"medalha de loot", "loot medal"},
	{"medalhas de loot", "loot medals"},
	{"mochila", "backpack"},
	{"mochilas", "backpacks"},
	{"bolsa", "bag"},
	{"bolsas", "bags"},
	{"mansao", "mansion"},
	{"dono", "owner"},
	{"senhor", "lord"},
	{"mestre", "master"},
	{"vampiro", "vampire"},
	{"vampiros", "vampires"},
	{"torre", "tower"},
	{"montanha", "mountain"},
	{"aqui", "here"},
	{"magia", "magic"},
	{"sombra", "shadow"},
	{"sombras", "shadows"},
	{"cadeira", "chairs"},
	{"cadeiras", "chairs"},
	{"mesa", "tables"},
	{"mesas", "tables"},
	{"movel", "furniture"},
	{"moveis", "furniture"},
	{"mobilia", "furniture"},
	{"almofada", "pillows"},
	{"almofadas", "pillows"},
	{"travesseiro", "pillows"},
	{"travesseiros", "pillows"},
	{"tapecaria", "tapestries"},
	{"tapecarias", "tapestries"},
	{"espelho", "mirrors"},
	{"espelhos", "mirrors"},
	{"cama", "beds"},
	{"camas", "beds"},
	{"outros", "more"},
	{"outras", "more"},
	{"pequena", "small"},
	{"pequenas", "small"},
	{"quadrada", "square"},
	{"quadradas", "square"},
	{"redonda", "round"},
	{"redondas", "round"},
	{"capacete", "helmets"},
	{"capacetes", "helmets"},
	{"bota", "boots"},
	{"botas", "boots"},
	{"armadura", "armors"},
	{"armaduras", "armors"},
	{"calca", "legs"},
	{"calcas", "legs"},
	{"escudo", "shields"},
	{"escudos", "shields"},
	{"espada", "swords"},
	{"espadas", "swords"},
	{"machado", "axes"},
	{"machados", "axes"},
	{"clava", "clubs"},
	{"clavas", "clubs"},
	{"martelo", "clubs"},
	{"martelos", "clubs"},
	{"primeira rod", "first rod"},
	{"primeira wand", "first wand"},
	{"primeiro rod", "first rod"},
	{"primeiro wand", "first wand"},
}, true)

-- Entrada: palavras em ingles -> keyword em portugues (scripts que so entendem portugues)
NpcLang.addAliases({
	{"help", "ajuda"},
	{"map", "mapa"},
	{"news", "noticias"},
	{"pickaxe", "picareta"},
	{"pick", "picareta"},
	{"elder", "anciao"},
	{"medium core", "nucleo medio"},
	{"highest core", "nucleo altissimo"},
	{"island", "ilha"},
	{"travel", "viajar"},
	{"trip", "viajar"},
}, false)
