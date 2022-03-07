extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animPlayer.connect("animation_finished", self, "_finishAnim")
	animPlayer.play("Idle") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("Attack"):
		$Sprite/Idle.hide()
		$Sprite/Death.show()
		$Hurtbox/CollisionShape2D.disabled = true
		get_node("Sprite").modulate = Color(10,10,10,10)
		yield(get_tree().create_timer(.1), "timeout")
		get_node("Sprite").modulate = Color(1,1,1,1)
		animPlayer.play("Death")
	
func _finishAnim(animName: String):
	if animName == "Death":
		queue_free()
