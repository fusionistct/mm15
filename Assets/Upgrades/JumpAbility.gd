extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if PlayerVariables.hasDoubleJump:
		print_debug("jump gone")
		queue_free()
	get_node("AnimationPlayer").play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		owner.playUpgradeSound()
		GameAudio.lowerVolume()
		PlayerVariables.hasDoubleJump = true
		owner.spawnText(["You recovered the Jet Boots.\nYour double jump capabilities have been restored.", "However, the one responsible for the theft is nowhere to be found."])
		queue_free()
