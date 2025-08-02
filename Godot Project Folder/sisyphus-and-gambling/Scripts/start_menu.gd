extends Node2D

#var main_scene = preload("res://Scenes/Main.tscn").instantiate()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/SlotsScreen.tscn")
