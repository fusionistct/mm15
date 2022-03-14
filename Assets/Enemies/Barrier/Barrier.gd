extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var flickerTimer;
onready var sprite = $DancingSquigglySnakeySnake;
onready var collider = $CollisionShape2D
export var flickers = true

# Called when the node enters the scene tree for the first time.
func _ready():
	flickerTimer = Timer.new()
	add_child(flickerTimer)
	flickerTimer.connect("timeout", self, "toggleWall")
	flickerTimer.set_wait_time(.5)
	flickerTimer.start()
	get_node("AnimationPlayer").play("Squiggle")

func toggleWall():
	if sprite.visible:
		sprite.hide()
		collider.disabled = true
	else:
		sprite.show()
		collider.disabled = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if PlayerVariables.hasDash and flickers:
		flickers = false
	if flickers == false and flickerTimer.time_left > 0:
		flickerTimer.stop()
		if !sprite.visible:
			toggleWall()
