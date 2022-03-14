extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var id : String

# Called when the node enters the scene tree for the first time.
func _ready():
	if PlayerVariables.healthCollected.has(id):
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		owner.playItemSound()
		PlayerVariables.healthCollected.append(id)
		if PlayerStats.health < PlayerStats.max_health:
			PlayerStats.set_health(PlayerStats.health + 1)
	queue_free()
