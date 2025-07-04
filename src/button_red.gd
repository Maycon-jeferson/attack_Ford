extends Area2D

var switch: bool

func switch_button():
	switch = !switch
	print(switch)
	sprinte_change()

func sprinte_change():
	if switch == false:
		print("button_off")
	
	if switch == true:
		print("button_on")
