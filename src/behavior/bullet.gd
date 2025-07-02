extends Area2D

@export var speed: float = 600.0
@export var lifetime: float = 2.0  # Tempo de vida da bala em segundos

var direction := Vector2.ZERO
var lifetime_timer: float = 0.0

func _ready() -> void:
	lifetime_timer = lifetime

func _process(delta: float) -> void:
	position += transform.x * speed * delta
	
	lifetime_timer -= delta
	if lifetime_timer <= 0.0:
		queue_free()
