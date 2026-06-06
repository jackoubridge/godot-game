extends Node2D

# Main player stats
@export var movement_speed: float = 200
@export var bullet_speed: float = 225
@export var bullet_damage: float = 1
@export var recoil_strength: float = bullet_speed / 3
@export var health_max: float = 10
@export var god_mode: bool = false

signal xp_update(value: int)
signal level_update(value: int)

var level:int = 1
var level_up_xp: int = 10
var xp: int = 0
var total_xp = 0

var health: float = health_max
var shoot_cooldown: float = 0.5
var last_damage_source = null

func add_xp(amount) -> void:
	xp += amount
	total_xp += amount
	if (xp >= level_up_xp):
		level_up()
	xp_update.emit(xp, level_up_xp)

func level_up() -> void:
	level += 1
	xp -= level_up_xp
	level_update.emit(level)
	level_up_xp = 5 * (2 ** level)
	xp_update.emit(xp, level_up_xp)
	await get_tree().create_timer(0.3).timeout
	var statToUpgrade: String = await $"../UpgradeScreen".upgrade_screen()

	match statToUpgrade:
		"movement_speed": movement_speed *= 1.2
		"bullet_damage": bullet_damage *= 1.2
		"shooting_speed": shoot_cooldown *= 0.8
		"health_max":
			health_max *= 1.2
			health *= 1.2

func take_damage(damage: float, owner_node) -> void:
	if not god_mode:
		health -= damage
		$"Health Bar".update(health, health_max)
		last_damage_source = owner_node

	if health <= 0:
		$"../GameOver".gameOver(total_xp)
