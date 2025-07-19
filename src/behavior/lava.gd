extends Area2D
@onready var botton: Area2D = $"../Button_red"
@onready var animation: AnimatedSprite2D = $animacao
@onready var colision: CollisionShape2D = $CollisionShape2D
var lava_behavior: bool

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and lava_behavior == false:
		call_deferred("reload_scene")

func reload_scene():
	get_tree().reload_current_scene()

#func _process(_delta: float) -> void:
		#if botton.switch == true:
			#lava_behavior = true
		#else:
			#lava_behavior = false
		#lava_behavior_metod()

func lava_behavior_metod():
	if lava_behavior == false:
		animation.play("lava")
		colision.disabled = false
	if lava_behavior == true:
		animation.play("dry")
		colision.disabled = true
