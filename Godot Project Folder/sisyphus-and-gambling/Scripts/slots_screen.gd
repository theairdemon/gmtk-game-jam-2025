extends Node2D

func _process(_delta: float) -> void:
	handle_esc_key()

func handle_esc_key() -> void:
	if Input.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")


func _on_return_to_the_mountain_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
	

func _on_exit_button_pressed() -> void:
	get_tree().quit()
