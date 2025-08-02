extends Node2D

var time_elapsed: float
var time_limit = 6

func _ready() -> void:
	time_elapsed = 0
	$Control/Countdown.clear()

func _process(delta: float) -> void:
	time_elapsed += delta
	
	if time_elapsed >= 0.9:
		$Control/Countdown.clear()
		$Control/Countdown.append_text(str(int(round(time_limit - time_elapsed))))
	
	if time_elapsed >= time_limit:
		get_tree().change_scene_to_file("res://Scenes/SlotsScreen.tscn")
