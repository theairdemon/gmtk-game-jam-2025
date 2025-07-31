extends Node2D

@export var player: Node2D

var offset_h = 25
var offset_v = 11

func _ready() -> void:
	offset_h = abs(offset_h)
	position = Vector2(player.position.x + offset_h, player.position.y - offset_v)

func _process(_delta: float) -> void:
	if player.velocity.x != 0:
		$BoulderSprite.rotation += offset_v
	
