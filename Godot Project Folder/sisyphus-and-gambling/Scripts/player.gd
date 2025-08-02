extends Node2D

@export var speed = 1
@export var jump_speed = 60
@export var jump_height = 40
@export var velocity: Vector2

var is_jumping: bool
var is_falling: bool
@export var init_position: Vector2

func _ready() -> void:
	position = Vector2(360,348)
	init_position = position

func _process(_delta: float) -> void:
	handle_reset()
	velocity = Vector2.ZERO

	#is_jumping = handle_jump(delta)
	#if not is_jumping:
	handle_push_boulder()

func handle_reset() -> void:
	if Input.is_action_pressed("DEBUG_reset"):
		position = init_position
		velocity = Vector2.ZERO

func handle_push_boulder() -> void:
	if Input.is_action_pressed("move_right"):
		velocity.x = 1
		velocity.y = -0.5
		$PlayerAnimation.animation = "walk uphill"
		$PlayerAnimation.play()
	if Input.is_action_pressed("move_left"):
		velocity.x = -1
		velocity.y = 0.5
		$PlayerAnimation.animation = "running left"
		$PlayerAnimation.play()
	
	if velocity.x == 0:
		$PlayerAnimation.animation = "walk uphill"
		$PlayerAnimation.set_frame_and_progress(0, 0)
		$PlayerAnimation.stop()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		if velocity.x > 0:
			velocity /= 2
		if velocity.x != 0:
			position += velocity
		if velocity.x > 0 and abs(position.x - init_position.x) < 5:
			position = init_position
	
#func handle_jump(delta: float) -> bool:
	#var y_difference = abs(position.y - init_position.y)
	#if y_difference >= jump_height:
		#is_falling = true
		#velocity.y -= 2
	#elif y_difference < 0.1:
		#is_falling = false
		#velocity.y = 0
#
	#if Input.is_action_pressed("move_up") and not is_falling:
		#velocity.y += 1
		#$PlayerAnimation.animation = "jump up"
		#$PlayerAnimation.play()
	#elif y_difference > 0.1:
		#is_falling = true
		#velocity.y -= 1
	#
	#if is_falling:
		##$PlayerAnimation.animation = "falling"
		#$PlayerAnimation.stop()
	#
	#if velocity.length() > 0:
		#velocity = velocity.normalized() * jump_speed
#
	#position.y -= velocity.y * delta
	#
	#return velocity.y != 0
	
