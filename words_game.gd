extends Node2D

var space_pressed = false
var space_pressed_duration = 0.0
var dot_or_dash

func _process(delta):
	if Input.is_action_pressed("ui_accept"):  # Check if the space bar is pressed
		if !space_pressed:
			space_pressed = true
			space_pressed_duration = 0.0
		space_pressed_duration += delta
	else:
		space_pressed = false

	if space_pressed:
		print("Space bar is pressed for " + str(space_pressed_duration) + " seconds")
	else:
		space_pressed_duration = 0.0
	
	return space_pressed_duration

func _dot_or_dash(space_pressed_duration):
	if space_pressed_duration == 0:
		dot_or_dash = ""
	elif space_pressed_duration > 0 && space_pressed_duration > 0.3:
		dot_or_dash = "dot"
	elif space_pressed_duration > 0.3:
		dot_or_dash = "dash"
