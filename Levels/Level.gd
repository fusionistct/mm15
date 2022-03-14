extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var textbox = $CanvasLayer/Textbox
onready var textLabel = $CanvasLayer/Textbox/RichTextLabel
onready var textTimer = $CanvasLayer/Textbox/Timer

var upgradeSound : AudioStream = preload("res://Sounds/upgrade.wav")
var itemSound : AudioStream = preload("res://Sounds/itemget.wav")
var hitSound : AudioStream = preload("res://Sounds/hit.wav")

onready var audio = get_node("AudioStreamPlayer")

func _process(delta):
	if Spawn.startGame and get_node("Player").is_on_floor():
		Spawn.startGame = false				
		spawnText(["Press A or Z to jump. Press S or X to attack.\nPress spacebar to confirm."])
		

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_node("Player")
	if Spawn.player_pos:
		player.global_position = Spawn.player_pos
	if Spawn.player_direction == -1:
		var hitboxPos = player.get_node("Hitbox/CollisionShape2D").get_position()
		var hurtboxPos = player.get_node("EnemyDetector").get_position()
		var attackSpritePos = player.get_node("Attack").get_position()
		player.get_node("Idle").set_flip_h( true )
		player.get_node("Run").set_flip_h( true )
		player.get_node("Dash").set_flip_h (true)
		player.get_node("Jump").set_flip_h (true)
		player.get_node("Fall").set_flip_h (true)
		player.get_node("Run").set_position(Vector2(2, 0))
		player.get_node("Jump").set_position(Vector2(2, 1))
		player.get_node("Fall").set_position(Vector2(2, 0))
		player.get_node("EnemyDetector").set_position(Vector2(-hurtboxPos.x, hurtboxPos.y))
		if not player.attackActive:
			player.get_node("Attack").set_flip_h( true )
			player.get_node("Attack").set_position(Vector2(-attackSpritePos.x, 0))
			player.get_node("Hitbox/CollisionShape2D").set_position(Vector2(-hitboxPos.x, hitboxPos.y))
		player.facingDirection = -1

func spawnText(dialog):
	var player = get_node("Player")
	textLabel.dialog = dialog
	textLabel.set_bbcode(dialog[0])
	textLabel.set_visible_characters(0)
	textLabel.page = 0
	textbox.visible = true
	textTimer.start()
	if player.is_on_floor() and player.currentSprite == player.runSprite:
		player._changeSprite(player.runSprite, player.idleSprite)
		
	get_tree().paused = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	get_tree().paused = !textbox.visible

func playUpgradeSound():
	audio.set_stream(upgradeSound)
	audio.set_volume_db(-7.0)
	audio.play()
	audio.seek(0)

func playItemSound():
	audio.set_stream(itemSound)
	audio.set_volume_db(10.0)
	audio.play()
	audio.seek(0)

func playHitSound():
	audio.set_stream(hitSound)
	audio.set_volume_db(2.0)
	audio.play()
	audio.seek(0)
