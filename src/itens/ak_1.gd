# weapon_pickup.gd
extends Area2D

@export var sprite_texture: Texture2D
@export var shoot_cooldown: float = 0.2
@export var recoil_force: float = 100.0
@export var bullet_speed: float = 600.0
@export var extra_behavior: Script  # pode ser um script que será instanciado

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		
		if body.has_method("equip_weapon"):
			print("pegou")
			body.equip_weapon({
				"sprite_texture": sprite_texture,
				"shoot_cooldown": shoot_cooldown,
				"recoil_force": recoil_force,
				"bullet_speed": bullet_speed,
				"extra_behavior": extra_behavior,
			})
		queue_free()
