extends Node2D

@export var player: Node2D

var offset_h = 75
var offset_v = 33

# State variables for process
var is_pushing: bool
var is_falling: bool
var is_rolling_up_correct: bool

# Variables for handle_falling
var last_push_time: float
var time_since_push: float

# Variables for check_if_rolling_up_correct
@export var input_roll_upwards: bool
var time_since_roll_switch = 0.0
var max_time_each_roll = 3.0

@export var init_position: Vector2

var rolling_speed = 0.01
var position_change = Vector2(1, -0.5).normalized()

func _ready() -> void:
	offset_h = abs(offset_h)
	position = Vector2(player.position.x + offset_h, player.position.y - offset_v)
	init_position = position
	is_falling = false
	last_push_time = Time.get_unix_time_from_system()
	input_roll_upwards = true

func _process(delta: float) -> void:
	handle_reset()
	is_pushing = check_if_pushing()
	is_rolling_up_correct = check_if_rolling_up_correct(delta)
	
	if not is_pushing or not is_rolling_up_correct:
		handle_falling()
	else:
		handle_pushing()

# Is the player pushing the boulder?
func check_if_pushing() -> bool:
	return player.velocity.x > 0 and position.x - offset_h - 5 < player.position.x and player.position.x < position.x + 5

# Is the player rolling up "correctly"
func check_if_rolling_up_correct(delta: float) -> bool:
	if not is_pushing:
		return true
	
	time_since_roll_switch += delta
	if time_since_roll_switch > max_time_each_roll:
		input_roll_upwards = not input_roll_upwards
		time_since_roll_switch = 0.0
	
	if input_roll_upwards:
		if Input.is_action_pressed("roll_upwards"):
			return true
	else:
		if Input.is_action_pressed("roll_downwards"):
			return true
	
	return false

# Boulder being pushed uphill
func handle_pushing() -> void:
	$BoulderSprite.rotation += rolling_speed
	if position != init_position:
		position += position_change / 2
	if abs(position.x - init_position.x) < 1:
		position = init_position
	last_push_time = Time.get_unix_time_from_system()

# Boulder rolling back down the hill
# is_falling indicates it's at max speed
func handle_falling() -> void:
	time_since_push = Time.get_unix_time_from_system() - last_push_time
	is_falling =  time_since_push > 5
		
	if is_falling:
		$BoulderSprite.rotation -= rolling_speed * 2
		position -= position_change
	elif time_since_push > 0.5:
		$BoulderSprite.rotation -= (rolling_speed * 2) / (5 / time_since_push)
		position -= position_change / (5 / time_since_push)
	
func handle_reset() -> void:
	if Input.is_action_pressed("DEBUG_reset"):
		position = init_position
		is_falling = false
		is_pushing = false
		last_push_time = Time.get_unix_time_from_system()
