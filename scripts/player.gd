extends CharacterBody2D

@export var speed: float = 200
@export var acceleration: float = 10
@export var friction: float = 5
@export var aim_speed: float = 50
@export var recoil_strength: float = 75

var bullet_path = preload("res://scenes/bullet.tscn")

func _process(delta: float) -> void:
	# Look at mouse - smoothed
	var target = (get_global_mouse_position() - global_position).angle()

	global_rotation = rotate_toward(
		global_rotation,
		target,
		aim_speed * delta
	)

func _physics_process(delta: float) -> void:
	# Movement
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	var velocity_x: float = 1.0 - exp( -(acceleration if input.x else friction) * delta)
	velocity.x = lerp(velocity.x, input.x * speed, velocity_x)
	var velocity_y: float = 1.0 - exp( -(acceleration if input.y else friction) * delta)
	velocity.y = lerp(velocity.y, input.y * speed, velocity_y)
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

	move_and_slide()
	
func shoot():
	var bullet = bullet_path.instantiate()
	bullet.dir = rotation
	bullet.pos = $Gun/BulletStart.global_position
	bullet.rot = global_rotation
	get_parent().add_child(bullet)

	var forward = transform.x
	var recoil_dir = -forward
	velocity += recoil_dir * recoil_strength
	
	$Gun.recoil()

func _on_area_2d_area_entered(_area: Area2D) -> void:
	pass
