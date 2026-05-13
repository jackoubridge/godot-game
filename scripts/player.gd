extends CharacterBody2D

@export var speed: float = 200
@export var acceleration: float = 10
@export var friction: float = 5

func _physics_process(delta: float) -> void:
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

	var velocity_x: float = 1.0 - exp( -(acceleration if input.x else friction) * delta)
	velocity.x = lerp(velocity.x, input.x * speed, velocity_x)

	var velocity_y: float = 1.0 - exp( -(acceleration if input.y else friction) * delta)
	velocity.y = lerp(velocity.y, input.y * speed, velocity_y)

	move_and_slide()
