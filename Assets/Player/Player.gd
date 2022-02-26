extends KinematicBody2D


var FLOOR_NORMAL = Vector2.UP

var jumpFrame = 0
var jump_buffer_frames_left = 0
var ground_buffer_frames_left = 0

onready var state_machine = $StateMachine
onready var animationPlayer = $AnimationPlayer
onready var attackAnimPlayer = $AttackAnimPlayer
onready var attackSprite = $Attack
onready var idleSprite = $Idle
onready var runSprite = $Run
onready var currentSprite = idleSprite
onready var attackActive = false

# Called when the node enters the scene tree for the first time.
func _ready():
	attackAnimPlayer.connect("animation_finished", self, "_finishAttack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and not attackActive:
		_playAnim(attackSprite)
		attackActive = true
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if self.is_on_floor():
		if direction !=0 and animationPlayer.get_current_animation() != "Run":
			_changeSprite(idleSprite, runSprite)
		if direction == 0 and animationPlayer.get_current_animation() == "Run":
			_changeSprite(runSprite, idleSprite)
	if not self.is_on_floor() and animationPlayer.get_current_animation() == "Run":
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
	to.show()
	animationPlayer.play(to.name)
	currentSprite = to

func _finishAttack(animName: String) -> void:
	if animName == "Attack":
		attackSprite.hide()
		attackActive = false
