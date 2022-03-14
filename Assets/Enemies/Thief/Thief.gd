extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animPlayer = $AnimationPlayer
onready var startLaugh = true
onready var disable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if PlayerVariables.thiefDead:
		queue_free()
	if not Spawn.endGameActive:
		$Idle.hide()
		$Laugh.show()
		animPlayer.play("Laugh")
	else:
		animPlayer.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if disable:
		$CollisionShape2D.disabled = true


func _on_RichTextLabel_dialog_finished():
	if startLaugh:
		$Idle.hide()
		$LaughStart.show()
		animPlayer.play("LaughStart")
		yield(animPlayer, "animation_finished")
		$LaughStart.hide()
		$Laugh.show()
		animPlayer.play("Laugh")
		startLaugh = false
		


func _on_Area2D_area_entered(area):
	if area.is_in_group("Attack"):
		disable = true
		PlayerVariables.thiefDead = true
		$Idle.hide()
		$LaughStart.hide()
		$Laugh.hide()
		$Disappear.show()
		animPlayer.play("Disappear")
		yield(animPlayer, "animation_finished")
		queue_free()
		
