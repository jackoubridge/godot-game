extends CharacterBody2D

@export var speed: float = 200
@export var acceleration: float = 10
@export var friction: float = 5
@export var aim_speed: float = 50
@export var recoil_strength: float = 75
@export var bullet_path: PackedScene

signal xp_update(value: int)
signal level_update(value: int)
var level:int = 1
var xp: int = 0
var can_shoot: bool = true

func _physics_process(delta: float) -> void:
	
	# Look at mouse - smoothed
	var target = (get_global_mouse_position() - global_position).angle()
	global_rotation = rotate_toward(global_rotation, target, aim_speed * delta)

	# Movement
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	var velocity_x: float = 1.0 - exp( -(acceleration if input.x else friction) * delta)
	velocity.x = lerp(velocity.x, input.x * speed, velocity_x)
	var velocity_y: float = 1.0 - exp( -(acceleration if input.y else friction) * delta)
	velocity.y = lerp(velocity.y, input.y * speed, velocity_y)
	
	if Input.is_action_pressed("shoot"):
		shoot()

	move_and_slide()
	
func shoot():
	if can_shoot:
		# Handle shoot cooldown
		can_shoot = false
		$Gun/Timer.start()

		# Spawn bullet
		var bullet = bullet_path.instantiate()
		bullet.dir = rotation
		bullet.pos = $Gun/BulletStart.global_position
		bullet.rot = global_rotation
		bullet.owner_node = self
		get_parent().add_child(bullet)

		# Give knockback to player
		var forward = transform.x
		var recoil_dir = -forward
		velocity += recoil_dir * recoil_strength
		
		# Play gun recoil animation
		$Gun.recoil()

func add_xp(amount):
	xp += amount
	
	if (xp >= 20):
		level += 1
		xp -= 20
		$Gun/Timer.wait_time = max(0.5 ** level, 0.5 ** 5)
	level_update.emit(level)
	xp_update.emit(xp)

# Collision detection
func _on_area_2d_area_entered(_area: Area2D) -> void:
	pass

# Handle shoot cooldown
func _on_timer_timeout() -> void:
	can_shoot = true
