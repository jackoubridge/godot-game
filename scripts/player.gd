extends CharacterBody2D

# Main player stats
@export var movement_speed: float = 200
@export var bullet_speed: float = 225
@export var bullet_damage: float = 1
@export var recoil_strength: float = bullet_speed / 3
@export var health_max: float = 10

@export var acceleration: float = 10
@export var friction: float = 5
@export var aim_speed: float = 50
@export var bullet_path: PackedScene

signal xp_update(value: int)
signal level_update(value: int)

var level:int = 1
var level_up_xp: int = 10
var xp: int = 0
var can_shoot: bool = true
var health: float = health_max

func _physics_process(delta: float) -> void:

	# Look at mouse - smoothed
	var target = (get_global_mouse_position() - global_position).angle()
	global_rotation = rotate_toward(global_rotation, target, aim_speed * delta)

	# Movement
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	var velocity_x: float = 1.0 - exp( -(acceleration if input.x else friction) * delta)
	velocity.x = lerp(velocity.x, input.x * movement_speed, velocity_x)
	var velocity_y: float = 1.0 - exp( -(acceleration if input.y else friction) * delta)
	velocity.y = lerp(velocity.y, input.y * movement_speed, velocity_y)

	if Input.is_action_pressed("shoot"):
		shoot()

	move_and_slide()

func shoot() -> void:
	if can_shoot:
		# Handle shoot cooldown
		can_shoot = false
		$Gun/Timer.start()

		# Spawn bullet
		var bullet = bullet_path.instantiate()

		bullet.owner_node = self
		bullet.pos = $Gun/BulletStart.global_position
		bullet.dir = rotation
		bullet.rot = global_rotation
		bullet.speed = bullet_speed
		bullet.damage = bullet_damage

		get_parent().add_child(bullet)

		# Give knockback to player
		var forward = transform.x
		var recoil_dir = -forward
		velocity += recoil_dir * recoil_strength
		
		# Play gun recoil animation
		$Gun.recoil()

func add_xp(amount) -> void:
	xp += amount

	if (xp >= level_up_xp):
		level += 1
		level_update.emit(level)
		xp -= level_up_xp
		level_up_xp = 5 * (2 ** level)
		$Gun/Timer.wait_time = max(0.5 ** level, 0.5 ** 5)
	xp_update.emit(xp, level_up_xp)

# Collision detection
func _on_area_2d_area_entered(_area: Area2D) -> void:
	pass

# Handle shoot cooldown
func _on_timer_timeout() -> void:
	can_shoot = true
