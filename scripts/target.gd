extends Node2D

class_name Target

@export var entity_id: String
@export var health_max: float
@export var xp_value: float
@export var attack_damage: float
@export var area_2d: Area2D

var pos: Vector2
var rot: float
var health: float
var last_damage_source = null
var is_destroying: bool = false

func _ready() -> void:
	global_position = pos
	health = health_max
	area_2d.global_rotation = rot
	reset_physics_interpolation()

	scale = Vector2.ZERO
	modulate.a = 0.0

	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.1)
	await tween.finished

func take_damage(damage: float, owner_node) -> void:
	health -= damage
	$"Health Bar".update(health, health_max)
	last_damage_source = owner_node
	if health <= 0:
		destroy()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		take_damage(area.damage, area.owner_node)

func destroy() -> void:
	is_destroying = true
	# Tell spawner this is destroyed
	global_signals.entity_destroyed.emit(self)

	# Give xp to damage source
	if (last_damage_source != null):
		if (last_damage_source.has_method("add_xp")):
			last_damage_source.add_xp(xp_value)

	# Death animation
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$"Health Bar".queue_free()
	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 0.1)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.1)
	await tween.finished

	# Destroy
	queue_free()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_entity_radius") and not is_destroying:
		destroy()
