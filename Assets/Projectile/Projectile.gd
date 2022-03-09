extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animPlayer.play("Spin")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Projectile_body_entered(body):
	if body is TileMap or body.name == "Player" :
		queue_free()
