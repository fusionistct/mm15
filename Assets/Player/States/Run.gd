extends State

onready var move = get_parent()

func unhandled_input(event: InputEvent) -> void:
	move.unhandled_input(event)

func physics_process(delta: float) -> void:
	if owner.is_on_floor():
		if move.get_move_direction().x == 0.0:
			_state_machine.transition_to("Move/Idle")
	else:
		_state_machine.transition_to("Move/Air")
		owner.ground_buffer_frames_left = 5
	move.physics_process(delta)

func enter(msg: Dictionary = {}) -> void:
#	owner.get_node("AnimatedSprite").animation = "run"
	if owner.currentSprite.name != "Run" and not move.dash and not owner.dead:
		owner._changeSprite(owner.currentSprite, owner.runSprite)
	move.enter(msg)

func exit() -> void:
#	owner.get_node("AnimatedSprite").animation = "stand"
	return
