extends AudioStreamPlayer

func _ready():
	var audioStream : AudioStream = preload("res://UI/Dialog/blip.wav")
	self.set_stream(audioStream)
	self.set_volume_db(0)
