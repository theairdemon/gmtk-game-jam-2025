extends Node2D

@export var speed = 100
@export var jump_speed = 20
@export var jump_height = 10
@export var velocity: Vector2

var is_jumping: bool
var is_falling: bool
var init_position: Vector2

func _ready() -> void:
	init_position = position

func _process(delta: float) -> void:
	velocity = Vector2.ZERO

	is_jumping = handle_jump(delta)
	if not is_jumping:
		handle_push_boulder()

func handle_push_boulder() -> void:
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	
	if velocity.x != 0:
		$PlayerAnimation.animation = "walk uphill"
		$PlayerAnimation.play()
		$PlayerAnimation.flip_h = velocity.x < 0
	else:
		$PlayerAnimation.animation = "walk uphill"
		$PlayerAnimation.set_frame_and_progress(0, 0)
		$PlayerAnimation.stop()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
func handle_jump(delta: float) -> bool:
	var y_difference = abs(position.y - init_position.y)
	if y_difference >= jump_height:
		is_falling = true
		velocity.y -= 1
	elif y_difference < 0.1:
		is_falling = false
		velocity.y = 0

	if Input.is_action_pressed("move_up") and not is_falling:
		velocity.y += 1
		$PlayerAnimation.animation = "jump up"
		$PlayerAnimation.play()
	elif y_difference > 0.1:
		is_falling = true
		velocity.y -= 1
	
	if is_falling:
		$PlayerAnimation.animation = "falling"
		$PlayerAnimation.play()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * jump_speed

	position.y -= velocity.y * delta
	
	return velocity.y != 0
	
