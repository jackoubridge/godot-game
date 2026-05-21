extends Area2D

var pos: Vector2
var rot: float
var dir: float

var speed: float = 225
var velocity: Vector2
var owner_node

func _ready():
	global_position = pos
	global_rotation = rot
	reset_physics_interpolation()	
	await get_tree().create_timer(5).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	velocity = Vector2(speed, 0).rotated(dir)
	position += velocity * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("target"):
		queue_free()
