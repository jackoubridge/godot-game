extends Node2D

# Main player stats
@export var movement_speed: float = 200
@export var bullet_speed: float = 225
@export var bullet_damage: float = 1
@export var recoil_strength: float = bullet_speed / 3
@export var health_max: float = 10

@export var bullet_path: PackedScene

signal xp_update(value: int)
signal level_update(value: int)

var level:int = 1
var level_up_xp: int = 10
var xp: int = 0
var can_shoot: bool = true
var health: float = health_max
var shoot_cooldown: float = 0.5

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot() -> void:
	if can_shoot:
		# Handle shoot cooldown
		can_shoot = false
		$CharacterBody2D/Gun/Timer.start(shoot_cooldown)

		# Spawn bullet
		var bullet = bullet_path.instantiate()

		bullet.owner_node = self
		bullet.pos = $CharacterBody2D/Gun/BulletStart.global_position
		bullet.dir = $CharacterBody2D.rotation
		bullet.rot = $CharacterBody2D.global_rotation
		bullet.speed = bullet_speed
		bullet.damage = bullet_damage

		add_child(bullet)

		# Play gun recoil animation
		$CharacterBody2D/Gun.recoil()

func add_xp(amount) -> void:
	xp += amount

	if (xp >= level_up_xp):
		level += 1
		level_update.emit(level)
		xp -= level_up_xp
		level_up_xp = 5 * (2 ** level)
		shoot_cooldown = max(0.5 ** level, 0.5 ** 5)
	xp_update.emit(xp, level_up_xp)

# Handle shoot cooldown
func _on_timer_timeout() -> void:
	can_shoot = true
