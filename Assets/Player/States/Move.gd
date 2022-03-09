extends State

"""
Written using GDQuest's platformer tutorial.

Parent state that abstracts and handles basic movement.
Move-related children states can delegate movement to it, or use its utility functions.
"""

export var max_speed_default = Vector2(125.0, 750.0)
export var acceleration_default = Vector2(10000.0, 500.0)
export var jump_impulse = 200.0

var acceleration = acceleration_default
var max_speed = max_speed_default
var velocity = Vector2.ZERO
var move_direction : Vector2

var knockback = false
var dead = false
var dash = false

onready var attackSpritePos = owner.get_node("Attack").get_position()
onready var hitboxPos = owner.get_node("Hitbox/CollisionShape2D").get_position()
onready var hurtboxPos = owner.get_node("EnemyDetector").get_position()

func unhandled_input(event: InputEvent) -> void:	
	if owner.is_on_floor() and not dead:
		if event.is_action_pressed("ui_accept"):
			_state_machine.transition_to("Move/Air", { impulse = jump_impulse })
	if Input.is_action_just_pressed("dash") and not dead:
		_state_machine.transition_to("Move/Dash")

func physics_process(delta: float) -> void:	
	var cancel_momentum = Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right")
	move_direction = Vector2.ZERO if knockback else get_move_direction()
	
	if knockback:
		move_direction = Vector2.ZERO
	else:
		if dead or dash:
			move_direction = Vector2(0, 1)
		if !dash:
			velocity = calculate_velocity(velocity, max_speed,
		acceleration, delta, move_direction, cancel_momentum)

	velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)
	
	if(move_direction.x<=-1):
		owner.get_node("Idle").set_flip_h( true )
		owner.get_node("Run").set_flip_h( true )
		owner.get_node("Dash").set_flip_h (true)
		owner.get_node("Jump").set_flip_h (true)
		owner.get_node("Fall").set_flip_h (true)
		owner.get_node("Run").set_position(Vector2(2, 0))
		owner.get_node("Jump").set_position(Vector2(2, 1))
		owner.get_node("Fall").set_position(Vector2(2, 0))
		owner.get_node("EnemyDetector").set_position(Vector2(-hurtboxPos.x, hurtboxPos.y))
		if not owner.attackActive:
			owner.get_node("Attack").set_flip_h( true )
			owner.get_node("Attack").set_position(Vector2(-attackSpritePos.x, 0))
			owner.get_node("Hitbox/CollisionShape2D").set_position(Vector2(-hitboxPos.x, hitboxPos.y))
		owner.facingDirection = -1
	elif(move_direction.x>=1):
		owner.get_node("Idle").set_flip_h( false )
		owner.get_node("Run").set_flip_h( false )
		owner.get_node("Dash").set_flip_h( false )
		owner.get_node("Jump").set_flip_h( false )
		owner.get_node("Fall").set_flip_h( false )
		owner.get_node("Run").set_position(Vector2(-2, 0))
		owner.get_node("Jump").set_position(Vector2(-2, 1))
		owner.get_node("Fall").set_position(Vector2(-2, 0))
		if not owner.attackActive:
			owner.get_node("Attack").set_flip_h( false )
			owner.get_node("Attack").set_position(Vector2(attackSpritePos.x, 0))
			owner.get_node("Hitbox/CollisionShape2D").set_position(Vector2(hitboxPos.x, hitboxPos.y))
		owner.facingDirection = 1
		
static func calculate_velocity(
		old_velocity: Vector2,
		max_speed: Vector2,
		acceleration: Vector2,
		delta: float,
		move_direction: Vector2,
		cancel_momentum: bool
	) -> Vector2:
	var new_velocity = old_velocity
	
	new_velocity += move_direction * acceleration * delta
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)
	
	if cancel_momentum:
		new_velocity.x = 0.0
	
	return new_velocity
	
static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 1.0
	)


func _on_EnemyDetector_body_entered(body):
	if body.is_in_group("Enemies"):
		owner.stats.health -= 1
		#print_debug("Health: ", owner.stats.health)
		print_debug(owner.global_position.x)
		print_debug(body.global_position.x)
		_state_machine.transition_to("Move/Damage", {other_body = body})
		owner.get_node("Hurt").modulate = Color(10,10,10,.8)
		yield(get_tree().create_timer(.05), "timeout")
		owner.get_node("Hurt").modulate = Color(1,1,1,1)
