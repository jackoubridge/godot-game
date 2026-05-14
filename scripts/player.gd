extends CharacterBody2D

@export var speed: float = 200
@export var acceleration: float = 10
@export var friction: float = 5
@export var aim_speed: float = 50

var bullet_path = preload("res://scenes/bullet.tscn")

func _physics_process(delta: float) -> void:
	
	# Movement
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	var velocity_x: float = 1.0 - exp( -(acceleration if input.x else friction) * delta)
	velocity.x = lerp(velocity.x, input.x * speed, velocity_x)
	var velocity_y: float = 1.0 - exp( -(acceleration if input.y else friction) * delta)
	velocity.y = lerp(velocity.y, input.y * speed, velocity_y)

	# Look at mouse - smoothed
	var v = get_global_mouse_position() - global_position
	var angle = v.angle()
	var r = global_rotation
	var angle_delta = aim_speed * delta
	angle = lerp_angle(r, angle, 0.3)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	global_rotation = angle
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

	move_and_slide()
	
func shoot():
	var bullet = bullet_path.instantiate()
	bullet.dir = rotation
	bullet.pos = $BulletStart.global_position
	bullet.rot = global_rotation
	get_parent().add_child(bullet)
