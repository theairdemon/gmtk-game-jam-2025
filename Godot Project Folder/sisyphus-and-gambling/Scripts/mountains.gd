extends Sprite2D

@export var player: Node2D

var init_position: Vector2
var clock_pos_y: int

func _init() -> void:
	init_position = position
	clock_pos_y = 0

func _physics_process(delta: float) -> void:
	if player.velocity.x != 0:
		position.x -= delta * 32
		position.y += delta * 2
		
		if abs(position.x - init_position.x) > 256:
			position = init_position
