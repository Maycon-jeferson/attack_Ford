extends Node2D

const bullet_scene = preload("res://src/behavior/bullet.tscn")
@onready var muzzle = $Muzzle

@export var shoot_cooldown: float = 0.3

var shoot_timer: float = 0.0

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	rotate_weapon()
	bullet_fire()
	shoot_timer -= delta
	
	

func rotate_weapon():
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
		
func bullet_fire():
	if Input.is_action_pressed("shoot") and shoot_timer <= 0.0:
		var bullet_instance = bullet_scene.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation
		shoot_timer = shoot_cooldown
