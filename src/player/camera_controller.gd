extends Camera2D

var zoom_min = Vector2(.5, .5)
var zoom_max = Vector2(3, 3)
var zoom_speed = Vector2(.2, .2)
var deslizant_zoom = Vector2(1, 1)  # Inicializa com zoom padrão

func _ready() -> void:
	# Garante que o zoom inicial seja válido
	zoom = Vector2(1, 1)

func _process(_delta: float) -> void:
	# Garante que o deslizant_zoom nunca seja zero ou muito pequeno
	deslizant_zoom.x = max(deslizant_zoom.x, 0.01)
	deslizant_zoom.y = max(deslizant_zoom.y, 0.01)
	
	zoom = lerp(zoom, deslizant_zoom, .2)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("zoon_in"):
			if deslizant_zoom > zoom_min:
				deslizant_zoom -= zoom_speed

			
		if event.is_action_pressed("zoon_out"):
			if deslizant_zoom < zoom_max:
				deslizant_zoom += zoom_speed
			
