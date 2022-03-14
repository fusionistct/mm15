extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var music_player

# Called when the node enters the scene tree for the first time.
func _ready():
	var music_file : AudioStream = preload("res://Sounds/mm15.wav")
	music_player = AudioStreamPlayer.new()
	music_player.pause_mode = Node.PAUSE_MODE_PROCESS
	add_child(music_player)
	music_player.set_stream(music_file)
	music_player.set_volume_db(-6)
	music_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#	pass
func lowerVolume():
	music_player.set_volume_db(-20)
	
func resetVolume():
	music_player.set_volume_db(-6)
	
func stopMusic():
	music_player.stop()
