extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var roomName : String
export (Vector2) var spawn_pos
export (int) var spawn_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Teleporter_body_entered(body):
	if body.name == "Player" and PlayerStats.health > 0:
		get_tree().change_scene("res://Levels/Rooms/" + roomName + ".tscn")
		Spawn.player_pos = spawn_pos
		Spawn.player_direction = spawn_direction
