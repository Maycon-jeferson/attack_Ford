# Documentação Passo a Passo - Sistema de Pickup de Texturas

## Visão Geral

Este documento explica como foi implementado o sistema que permite ao player pegar a textura de um item ao encostar nele, aplicando automaticamente essa textura na arma equipada.

## Passo 1: Análise da Estrutura Inicial

### 1.1 Estrutura do Player
```gdscript
// src/player/player.gd
extends CharacterBody2D

@onready var weapon: Node2D = $Weapon
var shoot_cooldown: float
var recoil_force: float

func equip_weapon(data: Dictionary):
    // Método existente que recebia dados da arma
    pass
```

### 1.2 Estrutura dos Itens
```gdscript
// src/itens/ak_1.gd e src/itens/shootgun.gd
extends Area2D

@export var sprite_texture: Texture2D
@export var shoot_cooldown: float
@export var recoil_force: float

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        body.equip_weapon({...})
        queue_free()
```

### 1.3 Estrutura da Arma
```
Weapon (Node2D)
├── Muzzle (Marker2D)
└── Sprite2D ← Aqui deve aparecer a textura
```

## Passo 2: Identificação dos Problemas

### 2.1 Problemas Encontrados:
1. **Player não estava no grupo "player"** - necessário para detecção de colisão
2. **Textura não estava sendo aplicada** - método equip_weapon não aplicava a textura
3. **Detecção de colisão limitada** - só funcionava com body_entered
4. **Textura não era obtida automaticamente** - precisava configurar manualmente

## Passo 3: Implementação das Correções

### 3.1 Adicionar Player ao Grupo
```gdscript
// src/player/player.gd
func _ready() -> void:
    # Adiciona o player ao grupo para detecção de colisão
    add_to_group("player")
```

**Por que isso é necessário:**
- Os itens verificam se o objeto que colidiu está no grupo "player"
- Sem isso, a detecção de colisão não funciona

### 3.2 Melhorar Detecção de Colisão
```gdscript
// src/itens/ak_1.gd e src/itens/shootgun.gd
func _on_body_entered(body: Node2D) -> void:
    handle_pickup(body)

func _on_area_entered(area: Area2D) -> void:
    # Se a área pertence ao player
    if area.get_parent() and area.get_parent().is_in_group("player"):
        handle_pickup(area.get_parent())

func handle_pickup(target: Node2D) -> void:
    if target.is_in_group("player"):
        if target.has_method("equip_weapon"):
            target.equip_weapon({...})
            queue_free()
```

**Por que isso é necessário:**
- `body_entered` detecta colisão com CharacterBody2D
- `area_entered` detecta colisão com Area2D
- Alguns objetos podem ter ambos os tipos de colisão

### 3.3 Obter Textura Automaticamente
```gdscript
// src/itens/ak_1.gd e src/itens/shootgun.gd
@onready var item_sprite: Sprite2D = $Sprite2D

func _ready() -> void:
    # Se não foi configurada uma textura específica, pega do sprite do item
    if not sprite_texture and item_sprite and item_sprite.texture:
        sprite_texture = item_sprite.texture

func handle_pickup(target: Node2D) -> void:
    if target.is_in_group("player"):
        # Garante que temos uma textura
        if not sprite_texture and item_sprite and item_sprite.texture:
            sprite_texture = item_sprite.texture
        
        if target.has_method("equip_weapon"):
            target.equip_weapon({
                "sprite_texture": sprite_texture,
                // ... outros dados
            })
            queue_free()
```

**Por que isso é necessário:**
- Não precisa mais configurar manualmente no Inspector
- Pega automaticamente a textura do Sprite2D do item
- Fallback para garantir que sempre há uma textura

### 3.4 Aplicar Textura na Arma
```gdscript
// src/player/player.gd
func equip_weapon(data: Dictionary):
    if data.has("sprite_texture"):
        # Aplica a textura na arma
        var weapon_sprite = weapon.get_node("Sprite2D")
        if weapon_sprite:
            weapon_sprite.texture = data["sprite_texture"]
    
    if data.has("shoot_cooldown"):
        shoot_cooldown = data["shoot_cooldown"]
        
    if data.has("recoil_force"):
        recoil_force = data["recoil_force"]
```

**Por que isso é necessário:**
- Busca o Sprite2D da arma
- Aplica a textura recebida do item
- Mantém os outros parâmetros (cooldown, recoil)

## Passo 4: Extensão para Posição do Muzzle

### 4.1 Adicionar Referência ao Muzzle do Item
```gdscript
// src/itens/ak_1.gd e src/itens/shootgun.gd
@onready var item_muzzle: Marker2D = $Muzzle

func handle_pickup(target: Node2D) -> void:
    if target.is_in_group("player"):
        if target.has_method("equip_weapon"):
            target.equip_weapon({
                "sprite_texture": sprite_texture,
                "shoot_cooldown": shoot_cooldown,
                "recoil_force": recoil_force,
                "bullet_speed": bullet_speed,
                "muzzle_position": item_muzzle.position if item_muzzle else Vector2(40, -4),
                "extra_behavior": extra_behavior,
            })
            queue_free()
```

### 4.2 Aplicar Posição do Muzzle na Arma
```gdscript
// src/player/player.gd
func equip_weapon(data: Dictionary):
    if data.has("sprite_texture"):
        # Aplica a textura na arma
        var weapon_sprite = weapon.get_node("Sprite2D")
        if weapon_sprite:
            weapon_sprite.texture = data["sprite_texture"]
    
    if data.has("muzzle_position"):
        # Aplica a posição do muzzle
        var weapon_muzzle = weapon.get_node("Muzzle")
        if weapon_muzzle:
            weapon_muzzle.position = data["muzzle_position"]
    
    // ... resto do código
```

## Passo 5: Preparação para Futuro Sprite2D do Player

### 5.1 Adicionar Referência ao Sprite2D do Player
```gdscript
// src/player/player.gd
# Referência para o futuro Sprite2D do player
@onready var player_sprite: Sprite2D = get_node_or_null("Sprite2D")

# Método para aplicar textura no sprite do player (futuro)
func set_player_texture(texture: Texture2D) -> void:
    if player_sprite:
        player_sprite.texture = texture
```

**Por que isso é necessário:**
- Quando adicionar Sprite2D ao player, já estará preparado
- Método `set_player_texture()` disponível para uso futuro

## Passo 6: Limpeza e Otimização

### 6.1 Remover Prints de Debug
- Removidos todos os `print()` desnecessários
- Código limpo e otimizado
- Mantida funcionalidade completa

### 6.2 Remover Arquivos de Debug
- Deletados scripts de teste temporários
- Mantida apenas documentação essencial

## Fluxo Completo do Sistema

### 1. **Inicialização**
```
Item carrega → _ready() → Adiciona ao grupo "weapon_item"
Player carrega → _ready() → Adiciona ao grupo "player"
```

### 2. **Detecção de Colisão**
```
Player encosta no item → _on_body_entered() ou _on_area_entered()
→ handle_pickup() → Verifica se é player
```

### 3. **Transferência de Dados**
```
Item → Obtém textura do Sprite2D próprio
Item → Obtém posição do Muzzle próprio
Item → Envia dados via equip_weapon()
```

### 4. **Aplicação na Arma**
```
Player → Recebe dados em equip_weapon()
Player → Aplica textura no Weapon/Sprite2D
Player → Aplica posição no Weapon/Muzzle
Player → Atualiza cooldown e recoil
```

### 5. **Limpeza**
```
Item → queue_free() (destruído)
Player → Arma equipada com nova aparência
```

## Estrutura Final dos Dados

```gdscript
{
    "sprite_texture": Texture2D,    // Textura da arma
    "shoot_cooldown": float,        // Tempo entre tiros
    "recoil_force": float,          // Força do recuo
    "bullet_speed": float,          // Velocidade da bala
    "muzzle_position": Vector2,     // Posição do muzzle
    "extra_behavior": Script        // Comportamento adicional
}
```

## Conclusão

O sistema foi implementado de forma modular e extensível, permitindo:
- **Detecção robusta** de colisão
- **Transferência automática** de texturas
- **Configuração flexível** de parâmetros
- **Preparação para futuras** expansões
- **Código limpo** e bem documentado 