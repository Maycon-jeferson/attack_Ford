extends Area2D

@export var speed: float = 600.0
var direction := Vector2.ZERO
func _process(delta: float) -> void:
	position += transform.x * speed * delta
	
	if not get_viewport_rect().has_point(global_position):
		queue_free()
