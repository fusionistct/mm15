extends StaticBody2D

#even sexier
export var SPIT_TIME = 1.3
var spitTimer
var projectile = preload("res://Assets/Projectile/Projectile.tscn")
var projectile_speed = -300

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").play("TurretStuff") # Replace with function body.
	spitTimer = Timer.new()
	add_child(spitTimer)
	spitTimer.connect("timeout", self, "spit")

func spit():
	var projectile_instance =  projectile.instance()
	projectile_instance.position = $Position2D.get_global_position()
	projectile_instance.apply_impulse(Vector2(), Vector2(projectile_speed, 0))
	get_tree().get_root().call_deferred("add_child", projectile_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (spitTimer.time_left == 0):
					spitTimer.set_wait_time(SPIT_TIME)
					spitTimer.start()
