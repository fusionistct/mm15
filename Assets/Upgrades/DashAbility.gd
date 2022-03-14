extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if PlayerVariables.hasDash:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		owner.playUpgradeSound()
		GameAudio.lowerVolume()
		PlayerVariables.hasDash = true
		owner.spawnText(["You acquired the dash booster.\nPress C or D to dash through obstacles.", "A powerful psychokinetic amplifier. Someone must have jammed it into the plant's key systems.", "The power currents have stabilized with its removal."])
		queue_free()
