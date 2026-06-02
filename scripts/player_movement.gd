extends CharacterBody2D

@export var acceleration: float = 10
@export var friction: float = 5
@export var aim_speed: float = 50
@export var player: Node2D

var game_over: bool = false

func _physics_process(delta: float) -> void:

	var input := Vector2.ZERO
	if not global_variables.game_over:
		input = Input.get_vector(
			"move_left",
			"move_right",
			"move_up",
			"move_down"
		).normalized()

		# Look at mouse - smoothed
		var target = (get_global_mouse_position() - global_position).angle()
		global_rotation = rotate_toward(global_rotation, target, aim_speed * delta)

	# Movement
	var velocity_x: float = 1.0 - exp(-(acceleration if input.x else friction) * delta)
	velocity.x = lerp(velocity.x, input.x * player.movement_speed, velocity_x)

	var velocity_y: float = 1.0 - exp(-(acceleration if input.y else friction) * delta)
	velocity.y = lerp(velocity.y, input.y * player.movement_speed, velocity_y)

	move_and_slide()

func knockback(recoil_strength: float) -> void:
	var forward = transform.x
	var recoil_dir = -forward
	velocity += recoil_dir * recoil_strength
	
# Collision detection
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("target"):
		player.take_damage(area.get_parent().attack_damage, area.get_parent())
