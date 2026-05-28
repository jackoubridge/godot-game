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

var health: float = health_max
var shoot_cooldown: float = 0.5

func add_xp(amount) -> void:
	xp += amount

	if (xp >= level_up_xp):
		level += 1
		level_update.emit(level)
		xp -= level_up_xp
		level_up_xp = 5 * (2 ** level)
		shoot_cooldown = max(0.5 ** level, 0.5 ** 5)
	xp_update.emit(xp, level_up_xp)
