extends Node2D

@export var player: Node2D

var offset_h = 25
var offset_v = 11

func _process(delta: float) -> void:
	if player.velocity.x != 0:
		offset_h = abs(offset_h) if player.velocity.x > 0 else -1 * abs(offset_h)
		position = Vector2(player.position.x + offset_h, player.position.y - offset_v)
		$BoulderSprite.rotation += offset_v
	
