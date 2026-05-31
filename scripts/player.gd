extends Node2D

# Main player stats
@export var movement_speed: float = 200
@export var bullet_speed: float = 225
@export var bullet_damage: float = 1
@export var recoil_strength: float = bullet_speed / 3
@export var health_max: float = 10

signal xp_update(value: int)
signal level_update(value: int)

var level:int = 1
var level_up_xp: int = 10
var xp: int = 0
var max_level: int = 5
var can_add_xp: bool = true

var health: float = health_max
var shoot_cooldown: float = 0.5
var last_damage_source = null

func add_xp(amount) -> void:
	if can_add_xp:
		xp += amount
		if (xp >= level_up_xp):
			level += 1
			if level == 5:
				can_add_xp = false
				xp = 0
			level_update.emit(level)
			xp -= level_up_xp
			level_up_xp = 5 * (2 ** level)
			shoot_cooldown = max(0.5 ** level, 0.5 ** 5)
		xp_update.emit(xp, level_up_xp)

func take_damage(damage: float, owner_node) -> void:
	health -= damage
	$"Health Bar".update(health, health_max)
	last_damage_source = owner_node

	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
