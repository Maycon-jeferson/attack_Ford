# Sistema de Pickup de Armas

## Como Funciona

O sistema permite que o player pegue armas ao encostar nelas, aplicando automaticamente a textura da arma no sprite da arma equipada.

### Componentes Principais

1. **Player** (`src/player/player.gd`)
   - Adicionado ao grupo "player" automaticamente
   - Possui método `equip_weapon()` que recebe dados da arma
   - Aplica a textura na arma equipada
   - Preparado para receber um Sprite2D no futuro

2. **Itens de Arma** (`src/itens/ak_1.gd`, `src/itens/shootgun.gd`)
   - Detectam colisão com o player
   - Pegam automaticamente a textura do próprio sprite
   - Enviam dados da arma (textura, cooldown, recuo, etc.)
   - São destruídos após o pickup

3. **Arma** (`weapon.gd`)
   - Recebe e aplica a textura do item
   - Usa os parâmetros (cooldown, recuo) do item equipado

### Como Usar

1. **Coloque itens na cena:**
   - Instancie `ak_1.tscn` ou `shootgun.tscn`
   - Posicione onde o player possa alcançar

2. **Configure as texturas:**
   - Os itens pegam automaticamente a textura do próprio Sprite2D
   - Ou configure manualmente no Inspector na propriedade `sprite_texture`

3. **Teste o pickup:**
   - Mova o player até encostar no item
   - A textura deve ser aplicada automaticamente na arma
   - O item deve desaparecer

### Estrutura de Dados

O método `equip_weapon()` recebe um Dictionary com:
```gdscript
{
    "sprite_texture": Texture2D,    # Textura da arma
    "shoot_cooldown": float,        # Tempo entre tiros
    "recoil_force": float,          # Força do recuo
    "bullet_speed": float,          # Velocidade da bala
    "muzzle_position": Vector2,     # Posição do muzzle da arma
    "extra_behavior": Script        # Comportamento adicional (opcional)
}
```

### Funcionalidades Importadas do Item

Quando o player pega uma arma, os seguintes dados são importados automaticamente:

1. **Textura**: Aplicada no Sprite2D da arma
2. **Posição do Muzzle**: Aplicada no Marker2D da arma
3. **Cooldown**: Tempo entre tiros
4. **Recoil**: Força do recuo
5. **Velocidade da Bala**: Velocidade das balas disparadas

### Futuro: Sprite2D do Player

O player está preparado para receber um Sprite2D no futuro:
- Referência `player_sprite` já configurada
- Método `set_player_texture()` disponível
- Quando adicionar o Sprite2D, a textura será aplicada automaticamente

### Estrutura Atual

```
Player (CharacterBody2D)
├── CollisionShape2D
├── ColorRect
├── Weapon (Node2D)
│   ├── Muzzle (Marker2D)
│   └── Sprite2D ← Textura da arma aplicada aqui
└── Sprite2D ← Futuro sprite do player

Item (Area2D)
├── CollisionShape2D
└── Sprite2D ← Textura original do item
``` 