extends Node2D

var health_max: float = 5
var health: float = health_max
var pos: Vector2
var rot: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = pos
	$Area2D.global_rotation = rot
	reset_physics_interpolation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if health <= 0:
		global_signals.target_destroyed.emit("triangle")
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		health -= 1
