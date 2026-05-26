extends Area2D

# Set by owner
var owner_node
var pos: Vector2
var rot: float
var dir: float
var speed: float
var damage: float

var velocity: Vector2

func _ready() -> void:
	global_position = pos
	global_rotation = rot
	reset_physics_interpolation()	
	await get_tree().create_timer(5).timeout
	destroy()

func _physics_process(delta: float) -> void:
	velocity = Vector2(speed, 0).rotated(dir)
	position += velocity * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("target"):
		destroy()

func destroy() -> void:
	# Death animation
	$CollisionShape2D.set_deferred("disabled", true)
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.01)
	await tween.finished

	queue_free()
