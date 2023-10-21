extends Node2D




func _on_button_4_pressed():
	get_tree().quit()


func _on_words_pressed():
	get_tree().change_scene_to_file("res://words_game.tscn")
	

func _on_letters_pressed():
	get_tree().change_scene_to_file("res://letters_game.tscn")
	


func _on_codes_pressed():
		get_tree().change_scene_to_file("res://codes_game.tscn")
