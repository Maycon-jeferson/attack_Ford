extends Camera2D

var zoom_min = Vector2(.1, .1)
var zoom_max = Vector2(2, 2)
var zoom_speed = Vector2 (.2, .2)
var deslizant_zoom = zoom

func _process(delta: float) -> void:
	zoom = lerp(zoom, deslizant_zoom, .2)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("zoon_in"):
			if deslizant_zoom > zoom_min:
				deslizant_zoom -= zoom_speed
			print("in")
			
		if event.is_action_pressed("zoon_out"):
			if deslizant_zoom < zoom_max:
				deslizant_zoom += zoom_speed
			print("out")
			
