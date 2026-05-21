extends Node2D

class_name Target

@export var target_type: global_enums.target_types
@export var health_max: float
@export var xp_value: float
@export var area_2d: Area2D
@export var health_bar: Node2D

var pos: Vector2
var rot: float
var health: float
var last_damage_source = null
signal health_update

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = pos
	health = health_max
	area_2d.global_rotation = rot
	reset_physics_interpolation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if health <= 0:
		global_signals.target_destroyed.emit(target_type)
		if last_damage_source != null:
			last_damage_source.add_xp(xp_value)
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		health -= 1
		health_update.emit() # Tell the health bar to update
		last_damage_source = area.owner_node
