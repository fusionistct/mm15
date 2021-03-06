extends Node

signal health_changed(health)
signal health_initialize(maxHealth)

var health = 0
export(int) var max_health = 2

func _ready() -> void:
	health = max_health
	emit_signal("health_initialize", max_health)
	emit_signal("health_changed", health)

func take_damage(amount):
	health -= amount
	health = max (0, health)
	emit_signal("health_changed", health)
	
func heal(amount):
	health += amount
	health = max(health, max_health)
	emit_signal("health_changed", health)
