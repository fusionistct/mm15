extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animPlayer = $AnimationPlayer
onready var dead = false

var projectile = preload("res://Assets/Projectile/Projectile.tscn")
var projectile_speed = 300

export var ACCELERATION = 300
export var MAX_SPEED = 90

#sexy
export var SPIT_TIME = 2
var spitTimer

enum {IDLE, SPIT, CHASE}
var state = IDLE
var direction = Vector2.ZERO

var velocity = Vector2.ZERO

onready var playerDetectionZone = $PlayerDetection

func spit():
	if not dead:
		animPlayer.seek(0, true)
		$Sprite/Idle.hide()
		$Sprite/Spit.show()
		animPlayer.play("Spit")
		yield(animPlayer, "animation_finished")
		state = SPIT
		if not dead:
			var projectile_instance =  projectile.instance()
			projectile_instance.position = $Position2D.get_global_position()
			projectile_instance.apply_impulse(Vector2(), Vector2(projectile_speed, 0))
			get_tree().get_root().call_deferred("add_child", projectile_instance)
		spitTimer.stop()
		animPlayer.seek(0, true)
		$Sprite/Spit.hide()
		$Sprite/Idle.show()
		animPlayer.play("Idle")
		state = IDLE
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	animPlayer.connect("animation_finished", self, "_finishAnim")
	animPlayer.play("Idle") # Replace with function body.
	spitTimer = Timer.new()
	add_child(spitTimer)
	spitTimer.connect("timeout", self, "spit")

func _physics_process(delta):
	#if Input.is_action_just_pressed("attack"):
	#	spit()
	#print_debug(direction)
	#print_debug($Sprite.get_scale())
	if direction.x > 0 and $Sprite.get_scale().x > 0:
		$Sprite.set_scale(Vector2(-1, 1))
		$Position2D.set_position(Vector2(-3, 2))
		projectile_speed = ACCELERATION - 100
	elif direction.x < 0 and $Sprite.get_scale().x < 0:
		$Sprite.set_scale(Vector2(1, 1))
		$Position2D.set_position(Vector2(3, 2))
		projectile_speed = -ACCELERATION - 100
		
	
	if dead:
		get_node("Collider").disabled= true
	else:
		match state:
			IDLE:
				velocity = Vector2.ZERO
				seek_player()
			SPIT:
				velocity = Vector2.ZERO
			CHASE:
				if (spitTimer.time_left == 0):
					spitTimer.set_wait_time(SPIT_TIME)
					spitTimer.start()
				var player = playerDetectionZone.player 
				if player != null:
					direction = (player.global_position - global_position).normalized()
					velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
					#velocity = Vector2.ZERO
				else:
					state = IDLE
					spitTimer.stop()
	velocity = move_and_slide(velocity)
		
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("Attack"):
		animPlayer.stop()
		animPlayer.seek(0)
		$Sprite/Idle.hide()
		$Sprite/Spit.hide()
		$Sprite/Death.show()
		dead = true
		get_node("Sprite").modulate = Color(10,10,10,10)
		yield(get_tree().create_timer(.1), "timeout")
		get_node("Sprite").modulate = Color(1,1,1,1)
		animPlayer.play("Death")
	
func _finishAnim(animName: String):
	if animName == "Death":
		queue_free()
