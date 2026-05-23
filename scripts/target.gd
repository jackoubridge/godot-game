extends Node2D

class_name Target

@export var target_id: String
@export var health_max: float
@export var xp_value: float
@export var area_2d: Area2D

var pos: Vector2
var rot: float
var health: float
var last_damage_source = null

func _ready() -> void:
	global_position = pos
	health = health_max
	area_2d.global_rotation = rot
	reset_physics_interpolation()

func take_damage(source: Area2D):
	health -= source.damage
	$"Health Bar".update()
	last_damage_source = source.owner_node
	if health <= 0:
		destroy()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		take_damage(area)

func destroy():
	global_signals.target_destroyed.emit(self)
	if last_damage_source != null:
		last_damage_source.add_xp(xp_value)

	# Death animation
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$"Health Bar".queue_free()
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.01)
	await tween.finished

	queue_free()
