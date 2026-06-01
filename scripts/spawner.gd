extends Node2D

class_name spawner

@export var entity_scene: PackedScene
@export var entity_id: String
@export var entity_threshold: int = 2
@export var is_static: bool
@export var radius_min: Vector2
@export var radius_max: Vector2

var entities: Array[Node2D] = []
var entity_speed: float

func _ready() -> void:
	if !is_static:
		$"../..".level_update.connect(update_thresholds)
	global_signals.entity_destroyed.connect(_on_entity_destroyed)

func _physics_process(_delta: float) -> void:
	if entities.size() < entity_threshold:
		spawn_entity(entity_scene)

func spawn_entity(entity_path: PackedScene) -> void:

	var entity = entity_path.instantiate()

	entities.append(entity)

	entity.is_static = is_static
	entity.speed = entity_speed

	var random_x = randf_range(radius_min.x, radius_max.x)
	var random_y = randf_range(radius_min.y, radius_max.y)
	if randf() < 0.5:
		random_x *= -1
	if randf() < 0.5:
		random_y *= -1

	await get_tree().create_timer(randf() * 2).timeout
	entity.pos = Vector2(random_x, random_y) + global_position
	entity.rot = randf_range(0, 2*PI)
	get_parent().get_parent().add_child(entity)

func _on_entity_destroyed(entity) -> void:
	if (entity.entity_id == entity_id):
		entities.erase(entity)

func update_thresholds(level: int) -> void:
	entity_threshold = min(2 ** level, 2 ** 5)
	entity_speed = 2 ** level
