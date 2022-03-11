extends KinematicBody2D

var FLOOR_NORMAL = Vector2.UP

var jumpFrame = 0
var jump_buffer_frames_left = 0
var ground_buffer_frames_left = 0

var stats = PlayerStats

onready var state_machine = $StateMachine
onready var animationPlayer = $AnimationPlayer
onready var attackAnimPlayer = $AttackAnimPlayer
onready var attackSprite = $Attack
onready var idleSprite = $Idle
onready var runSprite = $Run
onready var hurtSprite = $Hurt
onready var deathSprite = $Death
onready var dashSprite = $Dash
onready var jumpSprite = $Jump
onready var fallSprite = $Fall
onready var currentSprite = idleSprite
onready var attackActive = false

onready var collider = $EnemyDetector/CollisionShape2D

onready var facingDirection = 1
onready var lastAttackDirection = 1

onready var canDash = false
onready var canDoubleJump = false

onready var dead = false
onready var dash = false
onready var dashCooldown = false
onready var dashCooldownTimer
const DASH_COOLDOWN_TIME = .2

onready var invincible = false
var invincibilityTimer
const INVINCIBILITY_TIME = .3
const DASH_INVINCIBILITY_TIME = .2

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("Idle")
	stats.connect("no_health", self, "_death")
	attackAnimPlayer.connect("animation_finished", self, "_finishAttack")
	invincibilityTimer = Timer.new()
	dashCooldownTimer = Timer.new()
	add_child(invincibilityTimer)
	add_child(dashCooldownTimer)
	invincibilityTimer.connect("timeout", self, "_finishInvincibility")
	dashCooldownTimer.connect("timeout", self, "finishDashCooldown")	

func startDashCooldown():
	dashCooldown = true
	dashCooldownTimer.set_wait_time(DASH_COOLDOWN_TIME)
	dashCooldownTimer.start()
	
func finishDashCooldown():
	print_debug("entered")
	dashCooldownTimer.stop()		
	$Tween.interpolate_property(self, "modulate", 
		Color(1, 1, 1, 1), Color( 5, 5, 5, .8 ), .3, 
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	yield(get_tree().create_timer(.3), "timeout")
	$Tween2.interpolate_property(self, "modulate", 
		Color( 5, 5, 5, .8 ), Color(1, 1, 1, 1), .3,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween2.start()
	yield(get_tree().create_timer(.3), "timeout")
	dashCooldown = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		stats.set_health(stats.max_health)
		get_tree().change_scene("res://Levels/TestLevel.tscn")
	if dead:
		collider.disabled = true
	if invincible and !collider.disabled:
		collider.disabled = true
		if dash:
			invincibilityTimer.set_wait_time(DASH_INVINCIBILITY_TIME)
		else:
			invincibilityTimer.set_wait_time(INVINCIBILITY_TIME)
		invincibilityTimer.start()
	if Input.is_action_just_pressed("attack") and not attackActive and not dead and not state_machine.state.name == "Damage":
		_playAnim(attackSprite)
		attackActive = true
		lastAttackDirection = facingDirection
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if self.is_on_floor() and not dead:
		if direction !=0 and animationPlayer.get_current_animation() != "Run" and not dash:
			_changeSprite(idleSprite, runSprite)
		if direction == 0 and animationPlayer.get_current_animation() == "Run" and not dash:
			_changeSprite(runSprite, idleSprite)
	if not self.is_on_floor() and animationPlayer.get_current_animation() == "Run" and not dash:
		_changeSprite(runSprite, idleSprite)
	
func _playAnim(sprite: Sprite) -> void:
	if sprite == attackSprite:
		attackAnimPlayer.seek(0, true)
		sprite.show()
		attackAnimPlayer.play(sprite.name)
	else:
		animationPlayer.seek(0, true)
		sprite.show()
		animationPlayer.play(sprite.name)

func _changeSprite(from: Sprite, to: Sprite) -> void:
	animationPlayer.seek(0, true)
	from.hide()
	if not (dead and to != deathSprite):
		to.show()
	animationPlayer.play(to.name)
	currentSprite = to

func _finishAttack(animName: String) -> void:
	if animName == "Attack":
		attackSprite.hide()
		attackActive = false
		if facingDirection != lastAttackDirection:
			var attackNode = get_node("Attack")
			var hitboxNode = get_node("Hitbox/CollisionShape2D")
			attackNode.set_position(Vector2(-attackNode.get_position().x, attackNode.get_position().y))
			hitboxNode.set_position(Vector2(-hitboxNode.get_position().x, hitboxNode.get_position().y))
			attackNode.set_flip_h( true ) if facingDirection == -1 else attackNode.set_flip_h( false )

func _death():
	dead = true
	yield(get_tree().create_timer(2), "timeout")
	stats.set_health(stats.max_health)
	get_tree().change_scene("res://Levels/TestLevel.tscn")

func _finishInvincibility() -> void:
	invincible = false
	collider.disabled = false
	invincibilityTimer.stop()
