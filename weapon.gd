extends Node2D

const bullet_scene = preload("res://src/behavior/bullet.tscn")
@onready var muzzle = $Muzzle

@export var player: CharacterBody2D

var shoot_cooldown: float
var recoil_force: float
var shoot_timer: float = 0.0

# Variável para controlar o ângulo da arma ao redor do player
var angle_around_player: float = 0.0

# Offset do centro de rotação em relação ao player
@export var center_offset: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	var orbit_radius = 40.0 # ajuste conforme necessário
	if get_parent():
		# Calcula o ângulo entre o centro de rotação (WeaponPivot) e o mouse
		var mouse_pos = get_global_mouse_position()
		var center = get_parent().global_position
		angle_around_player = (mouse_pos - center).angle()
		# Calcula a nova posição ao redor do WeaponPivot
		var offset = Vector2(cos(angle_around_player), sin(angle_around_player)) * orbit_radius
		global_position = center + offset
		# Faz a arma olhar para o mouse
		look_at(mouse_pos)
	rotate_weapon()

	shoot_timer = max(shoot_timer - delta, 0.0)
	bullet_fire()

func rotate_weapon():
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	scale.y = -1 if rotation_degrees > 90 and rotation_degrees < 270 else 1

func bullet_fire():
	shoot_cooldown = player.shoot_cooldown
	recoil_force = player.recoil_force
	
	
	if Input.is_action_pressed("shoot") and shoot_timer <= 0.0 and not shoot_cooldown == 0.0:
		var bullet_instance = bullet_scene.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation
		shoot_timer = shoot_cooldown

		# Aplica recuo no player (direção oposta ao tiro)
		if player and player.has_method("apply_recoil"):
			# Calcula a direção do recoil baseada na rotação da arma
			var recoil_direction = Vector2(-cos(rotation), -sin(rotation)).normalized()
			player.apply_recoil(recoil_direction * recoil_force)
