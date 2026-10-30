# Guia de Balanceamento de Combate & Velocidade de Ataque (Fist Fighting)

Este documento detalha as implementações, regras matemáticas e mecânicas desenvolvidas para o servidor **The Forgotten Server (TFS 1.8 - 8.60 Downgrade)**:
> *"2.5 as spells por skills"*, *"0.5 magia"*, *"0.2 itens"*, *"escalonamento"* e *"ao treinar skill de fist, aumentar a velocidade de ataque"*.

---

## 📌 Sumário
1. [Sistema de Escalonamento Global de Dano (Combat Scaling)](#1-sistema-de-escalonamento-global-de-dano-combat-scaling)
   - [Fórmula Ponderada](#fórmula-ponderada)
   - [Arquivo Central de Configuração](#arquivo-central-de-configuração)
   - [Spells Atualizadas](#spells-atualizadas)
2. [Sistema de Attack Speed por Treino de Fist Fighting](#2-sistema-de-attack-speed-por-treino-de-fist-fighting)
   - [Como Funciona](#como-funciona)
   - [Implementação Híbrida (C++ Core + Lua)](#implementação-híbrida-c-core--lua)
   - [Parâmetros Configuráveis no config.lua](#parâmetros-configuráveis-no-configlua)
   - [Simulação de Evolução de Velocidade](#simulação-de-evolução-de-velocidade)
3. [A Skill Shielding & Defesa para Todas as Vocações](#3-a-skill-shielding--defesa-para-todas-as-vocações)
4. [Configuração de Comportamento de Ataque (classicAttackSpeed)](#4-configuração-de-comportamento-de-ataque-classicattackspeed)
5. [Controle de Versão (Git Branch & GitHub Actions)](#5-controle-de-versão-git-branch--github-actions)

---

## 1. Sistema de Escalonamento Global de Dano (Combat Scaling)

### Fórmula Ponderada
A regra estabelece o peso dos atributos no cálculo base do dano:
* **`Skill * 2.5`**: Para cada ponto de Skill de combate (Sword, Axe, Club, Distance, Fist ou Shielding), soma-se **2.5 de dano base**.
* **`MagicLevel * 0.5`**: Para cada nível mágico (ML), soma-se **0.5 de dano base**.
* **`ItemAttack * 0.2`**: O ataque da arma equipada contribui com **0.2 (20%)** do seu valor.
* **`Level * 0.2`**: Mantém o clássico `Level / 5` tradicional do Tibia.

$$\text{Dano Base} = (\text{Level} \times 0.2) + (\text{Skill} \times 2.5) + (\text{MagicLevel} \times 0.5) + (\text{ItemAttack} \times 0.2)$$

### Arquivo Central de Configuração
Para evitar ter que alterar dezenas de arquivos de magias individualmente no futuro, criamos um módulo central:
📁 `data/scripts/lib/combat_scaling.lua`

Neste arquivo, você encontra a tabela mestra:
```lua
CombatScalingConfig = {
    enabled = true,

    -- [COMBATE FÍSICO / HÍBRIDO (Knight, Paladin, Monk)]
    physical = {
        skillWeight = 2.5,  -- 2.5 por ponto de Skill
        magicWeight = 0.5,  -- 0.5 por ponto de Magic Level
        itemWeight  = 0.2,  -- 0.2 por ponto de Attack da arma/item
        levelWeight = 0.2,  -- level / 5
    },

    -- [COMBATE MÁGICO (Sorcerer, Druid)]
    mage = {
        levelWeight = 0.2,
        itemWeight  = 0.2,  -- 0.2 do ataque da Wand/Rod equipada
        enableItemBonus = true,
    },

    globalDamageMultiplier = 1.0 -- Ajuste fino global
}
```
> **Como calibrar:** Se quiser testar os skills com peso `3.0` ou itens com peso `0.3`, altere apenas os números em `combat_scaling.lua` e use `/reload scripts` no jogo. Todas as magias se ajustam automaticamente.

### Spells Atualizadas
As seguintes magias foram migradas para o novo escalonamento:
* **Knight:**
  * `exori` (`berserk.lua`) - Dano em área equilibrado (multiplicadores 0.85 a 1.25).
  * `exori gran` (`fierce_berserk.lua`) - Área pesada de alto consumo (1.45 a 2.10).
  * `exori mas` (`groundshaker.lua`) - Grande área circular (0.90 a 1.35).
  * `exori hur` (`whirlwind_throw.lua`) - À distância, cooldown rápido (0.60 a 0.90).
  * `exori ico` (`brutal_strike.lua`) - Alvo único corpo-a-corpo (0.95 a 1.35).
  * `exori min` (`front_sweep.lua`) - Onda frontal (1.10 a 1.65).
  * `exori gran ico` (`annihilation.lua`) - Golpe finalizador (2.20 a 3.10).
  * `shield_bash.lua` & `shield_slam.lua` - Magias de escudo com peso 2.5 de Shielding.
* **Paladin:**
  * `exori con` (`ethereal_spear.lua`) - Baseada em Distance Skill + Ataque da lança/flecha + ML + Level.
  * `exori gran con` (`strong_ethereal_spear.lua`) - Versão avançada à distância.
* **Sorcerer & Druid:**
  * `exori frigo` (`ice_strike.lua`), `exori tera` (`terra_strike.lua`), `exori vis` (`energy_strike.lua`) - Preservam o dano arcano e integram o bônus de 0.2 do item/wand equipado.

---

## 2. Sistema de Attack Speed por Treino de Fist Fighting

### Como Funciona
* No Tibia, a velocidade de ataque é medida em **milissegundos entre cada golpe** (`attackSpeed`).
* **Aumentar a velocidade de ataque significa REDUZIR o tempo em milissegundos** entre um golpe e outro (menos espera = mais golpes por segundo).
* Ao criar o personagem (Fist 10), ele começa na velocidade base da sua vocação (ex: 250 ms em `vocations.xml`). Conforme treina Fist Fighting, o intervalo diminui de forma contínua e automática.

### Implementação Híbrida (C++ Core + Lua)
1. **O Cálculo Matemático é feito no C++ (Source):**
   * Local: `src/player.cpp` na função `Player::getAttackSpeedBeforeEquipmentBonus()`.
   * **Vantagens:** Executa em $O(1)$ sem lag de scripts; reconhece instantaneamente se o jogador equipar um anel que dê Fist, receber bônus temporário, morrer ou resetar.
2. **O Feedback ao Jogador é feito em Lua:**
   * Local: `data/scripts/creaturescripts/systems/fist_attackspeed.lua`.
   * Ao avançar no skill de Fist, envia uma mensagem branca informativa no console do jogador informando o seu novo intervalo de ataque em milissegundos.

### Parâmetros Configuráveis no config.lua
No arquivo `config.lua` (e `config.lua.dist`), você pode controlar o sistema sem precisar recompilar:

```lua
-- Fist Fighting Attack Speed
fistAttackSpeedEnabled = true        -- Ativa ou desativa o sistema
fistAttackSpeedMsPerSkill = 1         -- Quantos milissegundos reduz por nível de Fist acima de 10
fistAttackSpeedMinInterval = 100      -- Limite mínimo permitido em ms (piso de segurança)
```

* **`fistAttackSpeedMsPerSkill` (O Acelerador):** Define o ganho por ponto. Com valor `1`, cada 10 skills de fist diminuem 10 ms do intervalo.
* **`fistAttackSpeedMinInterval` (O Limitador):** Garante que o intervalo nunca fique menor que 100 ms (10 ataques por segundo). Isso impede travamentos de animação e dessincronização visual com o cliente do jogo.

### Simulação de Evolução de Velocidade
Considerando o valor base padrão de `250 ms` em `vocations.xml`:

| Nível de Fist | Níveis Acima da Base (10) | Redução (ms) | Intervalo Final | Ataques por Segundo |
| :---: | :---: | :---: | :---: | :---: |
| **Fist 10 (Início)** | 0 | 0 ms | **250 ms** | 4.0 hits/s |
| **Fist 30** | 20 | 20 ms | **230 ms** | 4.3 hits/s |
| **Fist 60** | 50 | 50 ms | **200 ms** | 5.0 hits/s |
| **Fist 90** | 80 | 80 ms | **170 ms** | 5.8 hits/s |
| **Fist 110** | 100 | 100 ms | **150 ms** | 6.6 hits/s |
| **Fist 160+ (Cap)** | 150+ | 150 ms | **100 ms (Mínimo)** | 10.0 hits/s (Teto máximo) |

---

## 3. A Skill Shielding & Defesa para Todas as Vocações

### Todas as vocações se beneficiam de Shielding?
**Sim!** No motor do TFS:
1. **Bloqueio Físico (`Player::getDefense`):** Qualquer vocação empunhando um escudo calcula a absorção de dano físico combinando a defesa do escudo com o seu nível de `SKILL_SHIELD`.
2. **Mitigação Percentual (`Player::getMitigation`):** O sistema moderno de mitigação do TFS lê `shieldingSkill * vocation->primaryShieldMultiplier`, reduzindo uma porcentagem líquida de todo o dano recebido.
3. **Spells Ofensivas de Escudo:** As habilidades `shield_bash.lua` e `shield_slam.lua` foram rebalanceadas para aplicar o mesmo fator de `2.5` por ponto de Shielding, tornando o treino de escudo ofensivamente relevante para Knights.

---

## 4. Configuração de Comportamento de Ataque (classicAttackSpeed)

No arquivo `config.lua`, você pode configurar a interação entre o auto-ataque e o uso de outros itens/magias:
* `classicAttackSpeed = true`: O ataque automático da arma é totalmente independente de poções ou magias (jogabilidade rápida e fluida de OTServer clássico).
* `classicAttackSpeed = false`: O ataque da arma respeita a fila de exaustão do personagem (usar poções ou itens pode atrasar ligeiramente o golpe da arma).

---

## 5. Controle de Versão (Git Branch & GitHub Actions)

Para proteger a integridade do servidor:
* A branch `main` foi mantida intacta e protegida.
* Todas as alterações de código (C++, scripts Lua e configurações) foram commitadas na branch:
  👉 **`feat/combat-scaling-and-fist-speed`**

### Repositório Remoto:
* Repositório: [`https://github.com/JV-071/forgottenserver-downgrade-1.8-8.60`](https://github.com/JV-071/forgottenserver-downgrade-1.8-8.60)
* Branch: `feat/combat-scaling-and-fist-speed`
* Compilação contínua (GitHub Actions): Os workflows para **Linux (Ubuntu/GCC)**, **Linux (Clang)** e **Windows (vcpkg)** são acionados automaticamente a cada atualização na branch.
