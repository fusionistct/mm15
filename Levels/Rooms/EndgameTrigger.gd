extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var textPhase = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not Spawn.endGameActive:
		get_node("CollisionShape2D").disabled = true


func _on_EndgameTrigger_body_entered(body):
	if body.name == "Player":
		Spawn.endGameActive = false
		GameAudio.stopMusic()
		owner.spawnText(["Unknown hostile lifeform detected.\nSubject is likely responsible for the theft of your tools."])
		
	


func _on_RichTextLabel_dialog_finished():
	if textPhase == 1:
		yield(get_tree().create_timer(.1), "timeout")
		owner.spawnText(["...", "Interference detected.\nFacility catastrophic meltdown imminent.", "Escape advised."])
		textPhase += 1
	elif textPhase == 2:
		PlayerVariables.timerActive = true
		Spawn.activate() 
