extends Sprite2D

@export var player: Node2D
@export var boulder: Node2D
@export var totalSteps: RichTextLabel
@export var daysPushed: RichTextLabel
@export var rollUpKey: RichTextLabel
@export var globalEarnings: RichTextLabel

var init_position: Vector2
var pos_multiplier = 2
var total_time_pushing = 0

func _init() -> void:
	init_position = position

func _ready() -> void:
	daysPushed.clear()
	daysPushed.append_text("Day " + str(format_cash(int(round(Time.get_unix_time_from_system())))))
	
	Globals.step_count = 0
	totalSteps.clear()
	totalSteps.append_text(str(Globals.step_count) + " steps")
	
	globalEarnings.clear()
	globalEarnings.append_text("Total Cash: $" + str(format_cash(Globals.global_earnings)))

func _process(delta: float) -> void:
	handle_esc_key()
	if is_player_pushing():
		position.x -= delta * 16 * pos_multiplier
		position.y += delta * pos_multiplier
		
		if abs(position.x - init_position.x) > 768:
			position = init_position
		
		handle_total_steps_text(delta)
		handle_roll_up_key_text()

static func format_cash(number, prefix=''):
	number = int(number)
	var neg = false
	if number < 0:
		number = -number
		neg = true
	var string = str(number)
	var mod = string.length() % 3
	var res = ""
	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ","
		res += string[i]
	if neg: res = '-'+prefix+res
	else: res = prefix+res
	return res

func handle_esc_key() -> void:
	if Input.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")

func handle_roll_up_key_text() -> void:
	rollUpKey.clear()
	rollUpKey.append_text("Enter" if boulder.input_roll_upwards else "Shift")

func handle_total_steps_text(delta: float) -> void:
	total_time_pushing += delta
	Globals.step_count = int(round(total_time_pushing / 1.5))
	totalSteps.clear()
	totalSteps.append_text(str(Globals.step_count) + " steps")

func is_player_pushing() -> bool:
	return player.velocity.x != 0 and boulder.position == boulder.init_position and player.position == player.init_position
