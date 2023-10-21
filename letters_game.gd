extends Node2D 

var end_counter = 0
var fail_counter = 0
var space_pressed = false
var space_pressed_duration = 0.0
var morse_input = ""
var start_time = 0.0
var end_time = 0.0
var duration = 0.0
var threshold:float = 200
var morse_matching = {"a": ".-","b": "-...","c": "-.-.","d": "-..","e": ".","f": "..-.","g": "--.","h": "....","i": "..","j": ".---","k": "-.-","l": ".-..","m": "--","n": "-.","o": "---","p": ".--.","q": "--.-","r": ".-.","s": "...","t": "-","u": "..-","v": "...-","w": ".--","x": "-..-","y": "-.--","z": "--.."}
var pause_time = 0
var pressing = true
var failed = false
var alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
var alph_index = 0

func _ready():
	# Load a new image from your project resources
	# Assign the new image to the Sprite node
	$Control/Letter.texture = load("res://morse/%s_morse.png".replace("%s", alphabet[alph_index]))
	
func _process(delta):
	if !pressing:
		pause_time += delta
		if pause_time > (threshold*0.01):
			#morse_input += " "
			check_input()
			pause_time = 0
			morse_input = ""

	
func _input(_event):
	if Input.is_action_just_pressed('space_down'):
		start_time = Time.get_ticks_msec()
		pressing = true
		$Control/Output.text = ""

	elif Input.is_action_just_released('space_down'):
		end_time = Time.get_ticks_msec()
		duration = end_time - start_time
		dot_or_dash()
		duration = 0.0
		pressing = false
		pause_time = 0

func dot_or_dash():
	if duration <= threshold:
		morse_input += "."
	else:
		morse_input += "-"
	$Control/Input.text = morse_input

func check_input():
		if morse_input == morse_matching[alphabet[alph_index]]:
			end_counter += 1
			if end_counter == 26:
				$Control/Output.text = "Congratulations!"
				get_tree().create_timer(5)
				change_scene()
				return
			$Control/Output.text = "Nice! Onto the next one"
			alph_index += 1
			$Control/Letter.texture = load("res://morse/%s_morse.png".replace("%s", alphabet[alph_index]))
			pressing = true
			$Control/Input.text = ""
		else:
			$Control/Output.text = "Wrong try again" 
			fail_counter += 1
			pressing = true
			$Control/Input.text= ""
			

func change_scene():
	get_tree().change_scene_to_file("res://main.tscn")
