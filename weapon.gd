extends Node2D

const bullet_scene = preload("res://src/behavior/bullet.tscn")
@onready var muzzle = $Muzzle

@export var player: CharacterBody2D

var shoot_cooldown: float
var recoil_force: float
var shoot_timer: float = 0.0

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	rotate_weapon()

	shoot_timer = max(shoot_timer - delta, 0.0)
	bullet_fire()

func rotate_weapon():
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	scale.y = -1 if rotation_degrees > 90 and rotation_degrees < 270 else 1

func bullet_fire():
	shoot_cooldown = player.shoot_cooldown
	recoil_force = player.recoil_force
	print(shoot_cooldown, " ", recoil_force)
	
	if Input.is_action_pressed("shoot") and shoot_timer <= 0.0 and not shoot_cooldown == 0.0:
		var bullet_instance = bullet_scene.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation
		shoot_timer = shoot_cooldown

		# Aplica recuo no player
		if player and player.has_method("apply_recoil"):
			var recoil_direction = (player.global_position - muzzle.global_position).normalized()
			player.apply_recoil(recoil_direction * recoil_force)
