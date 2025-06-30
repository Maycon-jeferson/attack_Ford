# weapon_pickup.gd
extends Area2D

@export var sprite_texture: Texture2D
@export var shoot_cooldown: float = 0.8
@export var recoil_force: float = 300.0
@export var bullet_speed: float = 600.0
@export var extra_behavior: Script  # pode ser um script que será instanciado

@onready var item_sprite: Sprite2D = $Sprite2D
@onready var item_muzzle: Marker2D = $Muzzle

func _ready() -> void:
	# Adiciona ao grupo para debug
	add_to_group("weapon_item")
	
	# Se não foi configurada uma textura específica, pega do sprite do item
	if not sprite_texture and item_sprite and item_sprite.texture:
		sprite_texture = item_sprite.texture

func _on_body_entered(body: Node2D) -> void:
	handle_pickup(body)

func _on_area_entered(area: Area2D) -> void:
	# Se a área pertence ao player
	if area.get_parent() and area.get_parent().is_in_group("player"):
		handle_pickup(area.get_parent())

func handle_pickup(target: Node2D) -> void:
	if target.is_in_group("player"):
		# Garante que temos uma textura
		if not sprite_texture and item_sprite and item_sprite.texture:
			sprite_texture = item_sprite.texture
		
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
