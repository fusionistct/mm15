extends Node

var player_pos = null
var player_direction = 1
var startGame = false
var endGameActive = true
var timer

func _ready():
	timer = Timer.new()
	timer.connect("timeout", self, "finishTick")
	add_child(timer)
	
func activate():
	print_debug(true)
	timer.set_wait_time(1)
	timer.start()

func finishTick():
	if PlayerVariables.timeLeft == 0:
		var player = get_tree().get_root().get_node("Level").get_node("Player")
		player._death()
		player.state_machine.transition_to("Move/Damage", {other_body = null})
		timer.stop()
	elif PlayerVariables.timeLeft > 0:
		PlayerVariables.timeLeft -= 1
