extends Area2D

var switch: bool

@onready var animate = $AnimatedSprite2D

func switch_button():
	switch = !switch
	sprinte_change()

func sprinte_change():
	if switch == false:
		print("button_off")
		animate.play("button_red")
	
	if switch == true:
		print("button_on")
		animate.play("button_green")
