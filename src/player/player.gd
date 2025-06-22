extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = 400.0
@export var gravity: float = 900.0
@export var max_fall_speed: float = 1000.0

@onready var weapon: Node2D = $Weapon

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO

	# Movimento lateral
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1

	# Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = -jump_force

	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed

	# Aplica movimento
	velocity.x = direction.x * speed
	move_and_slide()
