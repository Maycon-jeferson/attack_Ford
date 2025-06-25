extends CharacterBody2D

@export var acceleration: float = 200.0
@export var max_speed_x: float = 500.0

@onready var weapon: Node2D = $Weapon

var max_fall_speed: float = 1000.0
var gravity: float = 900.0
var jump_force: float = 350.0
func _physics_process(delta: float) -> void:
	move(delta)

func move(delta: float):
	var direction = Vector2.ZERO

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1

	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = -jump_force

	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed

	# MOVIMENTO COM ACELERAÇÃO
	var target_velocity_x = direction.x * max_speed_x
	velocity.x = move_toward(velocity.x, target_velocity_x, acceleration * delta)

	move_and_slide()
# Método para aplicar recuo vindo da arma
func apply_recoil(force: Vector2) -> void:
	velocity += force
