extends Area2D

var switch_botton_red: bool = false

@onready var animate = $AnimatedSprite2D

func switch_button():
	switch_botton_red = !switch_botton_red
	sprinte_change()

func sprinte_change():
	if switch_botton_red == false:
		print("button_off")
		animate.play("button_red")
	
	if switch_botton_red == true:
		print("button_on")
		animate.play("button_green")
