extends Node2D

@export var player: Node2D

var offset_h = 75
var offset_v = 33

# State variables for process
var is_pushing: bool
var is_falling: bool
var is_rolling_up_correct: bool

# Multipler to make everything harder over time
var difficulty_mult = 1.0
var time_to_increase_difficulty = 5
var time_since_increase_difficulty = 0.0

# Variables for handle_falling
var last_push_time: float
var time_since_push: float

# Variables for check_if_rolling_up_correct
@export var input_roll_upwards: bool
var time_since_roll_switch = 0.0
var max_time_each_roll = 3.0

@export var init_position: Vector2

var rolling_speed_up = 0.01
var rolling_speed_down = 0.02
var position_change_down = Vector2(1, -0.5).normalized()
var position_change_up = Vector2(1, -0.5).normalized()

func _ready() -> void:
	offset_h = abs(offset_h)
	position = Vector2(player.position.x + offset_h, player.position.y - offset_v)
	init_position = position
	is_falling = false
	last_push_time = Time.get_unix_time_from_system()
	input_roll_upwards = true

func _process(delta: float) -> void:
	handle_reset()
	handle_increase_difficulty(delta)
	check_boulder_gone()
	is_pushing = check_if_pushing()
	is_rolling_up_correct = check_if_rolling_up_correct(delta)
	
	if not is_pushing or not is_rolling_up_correct:
		handle_falling()
	else:
		handle_pushing()

# Increase difficulty over time
func handle_increase_difficulty(delta: float) -> void:
	time_since_increase_difficulty += delta
	
	if time_since_increase_difficulty > time_to_increase_difficulty:
		difficulty_mult *= 1.05
		difficulty_mult = round(1000 * difficulty_mult)/1000
		time_since_increase_difficulty = 0
		#print("Difficulty increased to " + str(difficulty_mult))
		
		max_time_each_roll -= max_time_each_roll * 0.1
		rolling_speed_down *= difficulty_mult
		position_change_down *= difficulty_mult

func check_boulder_gone() -> void:
	if position.x < 0:
		get_tree().change_scene_to_file("res://Scenes/BoulderGone.tscn")

# Is the player pushing the boulder?
func check_if_pushing() -> bool:
	return player.velocity.x > 0 and position.x - offset_h - 5 < player.position.x and player.position.x < position.x + 5

# Is the player rolling up "correctly"
func check_if_rolling_up_correct(delta: float) -> bool:
	if not is_pushing:
		return true
		
	if time_since_roll_switch > (max_time_each_roll - randf_range(0, max_time_each_roll / 2)):
		input_roll_upwards = not input_roll_upwards
		time_since_roll_switch = 0.0
		
	if input_roll_upwards:
		if Input.is_action_pressed("roll_upwards"):
			if position == init_position:
				time_since_roll_switch += delta
			return true
	else:
		if Input.is_action_pressed("roll_downwards"):
			if position == init_position:
				time_since_roll_switch += delta
			return true
	
	return false

# Boulder being pushed uphill
func handle_pushing() -> void:
	$BoulderSprite.rotation += rolling_speed_up
	if position != init_position:
		position += position_change_up / 2
	if abs(position.x - init_position.x) < 1:
		position = init_position
	last_push_time = Time.get_unix_time_from_system()

# Boulder rolling back down the hill
# is_falling indicates it's at max speed
func handle_falling() -> void:
	time_since_push = Time.get_unix_time_from_system() - last_push_time
	is_falling =  time_since_push > 5
		
	if is_falling:
		$BoulderSprite.rotation -= rolling_speed_down * 2
		position -= position_change_down
	elif time_since_push > 0.5:
		$BoulderSprite.rotation -= (rolling_speed_down * 2) / (5 / time_since_push)
		position -= position_change_down / (5 / time_since_push)
	
func handle_reset() -> void:
	if Input.is_action_pressed("DEBUG_reset"):
		position = init_position
		is_falling = false
		is_pushing = false
		last_push_time = Time.get_unix_time_from_system()
