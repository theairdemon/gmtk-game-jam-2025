extends Node2D

@export var speed = 100
@export var velocity: Vector2

func _process(delta: float) -> void:
	velocity = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	#if Input.is_action_pressed("move_left"):
		#velocity.x -= 1
	
	if velocity.x != 0:
		$PlayerAnimation.animation = "walk uphill"
		$PlayerAnimation.play()
		$PlayerAnimation.flip_h = velocity.x < 0
	else:
		#$PlayerAnimation.animation = "standstill"
		$PlayerAnimation.draw_end_animation()
		$PlayerAnimation.stop()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	#position += velocity * delta
	
