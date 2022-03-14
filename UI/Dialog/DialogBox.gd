#DialogBox.gd

extends RichTextLabel


export var dialog = ["Here is some test dialogue in order to see if the box displays it properly.",
"And here is the second page!"]
var page = 0
var currentChar = 0
var finished = false

onready var audio = get_parent().get_node("AudioStreamPlayer")
onready var indicator = get_parent().get_node("NextIndicator")

signal dialog_finished

func _ready():
	set_bbcode(dialog[page])
	set_visible_characters(0)
	
func _process(delta):
	indicator.visible = finished

func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		if get_visible_characters() > get_total_character_count():
			if page < dialog.size()-1:
				finished = false
				page += 1
				set_bbcode(dialog[page])
				set_visible_characters(0)
				currentChar = 0
			else:
				emit_signal("dialog_finished")
				owner.visible = false
				get_tree().paused = false
				GameAudio.resetVolume()
		else:
			set_visible_characters(get_total_character_count())
			finished = true

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters() + 1)
	if get_visible_characters() == get_total_character_count():
		finished = true
	if get_visible_characters() <= get_total_character_count() and currentChar % 2 == 0:
		audio.play()
		audio.seek(0)
	currentChar += 1
