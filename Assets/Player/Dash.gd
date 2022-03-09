extends State

onready var move = get_parent()

const DASH_TIME = 0.20

#var knocked_away = false
var dash_direction: Vector2 

func physics_process(delta: float) -> void:
	move.physics_process(delta)
	move.velocity.y = 10;

func enter(msg: Dictionary = {}) -> void:
	#owner.dashing = true
	dash_direction = Vector2(1, 0)
	move.dash = true
	owner.dash = true
	owner.invincible = true
	owner._changeSprite(owner.currentSprite, owner.dashSprite)
	owner.runSprite.hide()
	#move.velocity = calculate_knock_back(dash_direction)
	move.velocity = Vector2(300 * owner.facingDirection, 0)
	yield(get_tree().create_timer(DASH_TIME), "timeout")
	move.dash = false
	owner.dash = false
	owner._changeSprite(owner.dashSprite, owner.idleSprite)
	#owner.dashing = false
	_state_machine.transition_to("Move/Idle")

func calculate_knock_back(knock_back_direction) -> Vector2:
	return move.calculate_velocity(
		Vector2.ZERO,
		move.max_speed * 2,
		Vector2(10000, 0),
		1.0,
		knock_back_direction,
		false
	)

