extends Sprite2D

@export var player: Node2D

var init_position: Vector2
var clock_pos_y: int

var pos_multiplier = 2

func _init() -> void:
	init_position = position
	clock_pos_y = 0

func _physics_process(delta: float) -> void:
	if player.velocity.x != 0:
		position.x -= delta * 16 * pos_multiplier
		position.y += delta * pos_multiplier
		
		if abs(position.x - init_position.x) > 256:
			position = init_position
