extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var id : String

# Called when the node enters the scene tree for the first time.
func _ready():
	if PlayerVariables.itemsCollected.has(id):
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		owner.playUpgradeSound()
		GameAudio.lowerVolume()
		PlayerStats.set_max_health(PlayerStats.max_health + 1)
		PlayerStats.set_health(PlayerStats.max_health)
		PlayerVariables.itemsCollected.append(id)
		owner.spawnText(["Psy-Barrier capacity increased.\nMaximum health upgraded."])
		queue_free()
