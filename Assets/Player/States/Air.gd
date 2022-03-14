extends State

onready var move = get_parent()
export var acceleration_x = 10000.0 #5000.0

var impulse = 200.0
var jumpCancelled = false
var hasDoubleJump = true

func unhandled_input(event: InputEvent) -> void:
	move.unhandled_input(event)

func physics_process(delta: float) -> void:
	move.physics_process(delta)
	if move.velocity.y < 0 and owner.currentSprite.name != "Jump" and not move.dash and not owner.dead:
		owner._changeSprite(owner.currentSprite, owner.jumpSprite)
	if move.velocity.y >= 0 and owner.currentSprite.name !="Fall" and not move.dash and not owner.dead:
		owner._changeSprite(owner.currentSprite, owner.fallSprite)
	
	if hasDoubleJump and Input.is_action_just_pressed("jump") and PlayerVariables.hasDoubleJump and owner.currentSprite == owner.fallSprite and not owner.dead:
		move.velocity.y = 0
		move.velocity += calculate_jump_velocity(impulse)
		hasDoubleJump = false
	
	owner.jumpFrame +=1
	
	if owner.jumpFrame < 10:
		if Input.is_action_just_released("jump"):
			jumpCancelled = true
	
	if owner.jumpFrame == 10 and (jumpCancelled or (!Input.is_action_pressed("jump") and move.velocity.y < 0)): 
		move.velocity.y = 0
		jumpCancelled = false
	
	if owner.jumpFrame >= 10:
		if Input.is_action_just_released("jump") and move.velocity.y < 0:
			move.velocity.y = 0
	
	if owner.ground_buffer_frames_left > 0:
		if Input.is_action_just_pressed("jump"):
			move.velocity.y = 0
			move.velocity += calculate_jump_velocity(impulse)
			owner.ground_buffer_frames_left = 0
			owner.jumpFrame = 0
		else:
			owner.ground_buffer_frames_left -=1
	
	if owner.jump_buffer_frames_left > 0:
		if owner.is_on_floor():
			move.velocity += calculate_jump_velocity(impulse)
			owner.jump_buffer_frames_left = 0
			owner.jumpFrame = 0
		else:
			owner.jump_buffer_frames_left -= 1
	elif Input.is_action_just_pressed("jump"):
		owner.jump_buffer_frames_left = 5
	
	elif owner.is_on_floor():
		owner.jumpFrame = 0
		var target_state = "Move/Idle" if move.get_move_direction().x == 0.0 else "Move/Run"
		_state_machine.transition_to(target_state)

func enter(msg: Dictionary = {}) -> void:
#	owner.get_node("AnimatedSprite").animation = "jump"
	move.enter(msg)
	move.acceleration.x = acceleration_x
	hasDoubleJump = true
	
	if !Input.is_action_pressed("jump") and owner.is_on_floor():
		jumpCancelled = true
	
	if "velocity" in msg:
		move.velocity = msg.velocity
		move.max_speed_x = max(abs(msg.velocity.x), move.max_speed_default.x)
	if "impulse" in msg:
		impulse = msg.impulse
		move.velocity += calculate_jump_velocity(impulse)

func exit() -> void:
#	owner.get_node("AnimatedSprite").animation = "stand"
	move.exit()
	move.acceleration = move.acceleration_default

func calculate_jump_velocity(impulse = 0.0) -> Vector2:
	if owner.dead:
		return Vector2.ZERO
	return move.calculate_velocity(
		move.velocity,
		move.max_speed,
		Vector2(0.0, impulse),
		1.0,
		Vector2.UP,
		false
	)
