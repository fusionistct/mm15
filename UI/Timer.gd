extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if PlayerVariables.timerActive:
		visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if PlayerVariables.timerActive:
		$RichTextLabel.set_bbcode(str(PlayerVariables.timeLeft))
	
	
