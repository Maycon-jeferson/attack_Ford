extends CharacterBody2D

@export var acceleration: float = 400.0
@export var max_speed_x: float = 500.0
@export var deceleration: float = 1000.0  # Desaceleração para simular chão ensaboado

var shoot_cooldown: float
var recoil_force: float
var recoil_velocity: Vector2 = Vector2.ZERO
var recoil_damping: float = 12.0 # quanto maior, mais rápido o recuo é amortecido
var max_recoil_speed: float = 350.0 # limite máximo para o recuo
#var bullet_speed: float

@onready var weapon: Node2D = $Weapon
# Referência para o futuro Sprite2D do player
@onready var player_sprite: Sprite2D = get_node_or_null("Sprite2D")

var max_fall_speed: float = 1000.0
var gravity: float = 1000.0
var jump_force: float = 350.0

func _ready() -> void:
	# Adiciona o player ao grupo para detecção de colisão
	add_to_group("player")

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

	# MOVIMENTO COM ACELERAÇÃO E DESACELERAÇÃO
	var target_velocity_x = direction.x * max_speed_x
	
	if direction.x != 0:
		# Aplicar aceleração quando há input
		velocity.x = move_toward(velocity.x, target_velocity_x, acceleration * delta)
	else:
		# Aplicar desaceleração quando não há input (chão ensaboado)
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

	if velocity.x > max_speed_x:
		velocity.x = max_speed_x
	elif velocity.x < -max_speed_x:
		velocity.x = -max_speed_x

	move_and_slide()

# Método para aplicar recuo vindo da arma
func apply_recoil(force: Vector2) -> void:
	# Aplica o recoil completo (horizontal e vertical)
	velocity += force
	
	# Limita a velocidade máxima do recoil horizontal
	if abs(velocity.x) > max_speed_x + 100:
		velocity.x = sign(velocity.x) * (max_speed_x + 100)
	
	# Limita a velocidade máxima do recoil vertical (pulo controlado)
	if velocity.y < -jump_force * 1.5:
		velocity.y = -jump_force * 1.5

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
	
	if data.has("shoot_cooldown"):
		shoot_cooldown = data["shoot_cooldown"]
		
	if data.has("recoil_force"):
		recoil_force = data["recoil_force"]

# Método para aplicar textura no sprite do player (futuro)
#func set_player_texture(texture: Texture2D) -> void:
	#if player_sprite:
		#player_sprite.texture = texture
