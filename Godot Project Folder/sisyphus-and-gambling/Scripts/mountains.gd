extends Sprite2D

@export var player: Node2D
@export var boulder: Node2D
@export var totalSteps: RichTextLabel
@export var daysPushed: RichTextLabel
@export var rollUpKey: RichTextLabel

var init_position: Vector2
var pos_multiplier = 2
var total_time_pushing = 0
var total_step_count = 0

func _init() -> void:
	init_position = position

func _ready() -> void:
	daysPushed.clear()
	daysPushed.append_text("Day " + str(int(round(Time.get_unix_time_from_system()))))

func _process(delta: float) -> void:
	if is_player_pushing():
		position.x -= delta * 16 * pos_multiplier
		position.y += delta * pos_multiplier
		
		if abs(position.x - init_position.x) > 768:
			position = init_position
		
		handle_total_steps_text(delta)
		handle_roll_up_key_text()

func handle_roll_up_key_text() -> void:
	rollUpKey.clear()
	rollUpKey.append_text("Enter" if boulder.input_roll_upwards else "Shift")

func handle_total_steps_text(delta: float) -> void:
	total_time_pushing += delta
	total_step_count = int(round(total_time_pushing / 1.5))
	totalSteps.clear()
	totalSteps.append_text(str(total_step_count) + " steps")

func is_player_pushing() -> bool:
	return player.velocity.x != 0 and boulder.position == boulder.init_position and player.position == player.init_position
