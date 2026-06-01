extends Node2D

class_name spawner

@export var entity_scene: PackedScene
@export var entity_id: String
@export var entity_threshold: int = 2
@export var is_static: bool
@export var radius_min: float
@export var radius_max: float
@export var bias_edges: bool = true

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

	var angle = randf_range(0.0, TAU)

	var bias = randf()
	if bias_edges == true:
		bias = randf()**0.25

	var radius = lerp(radius_min, radius_max, bias)

	await get_tree().create_timer(randf() * 3).timeout
	entity.pos = Vector2(cos(angle) * radius, sin(angle) * radius) + global_position
	entity.rot = randf_range(0, 2*PI)
	get_parent().get_parent().add_child(entity)

func _on_entity_destroyed(entity) -> void:
	if (entity.entity_id == entity_id):
		entities.erase(entity)

func update_thresholds(level: int) -> void:
	entity_threshold = min(2 ** level, 2 ** 5)
	entity_speed = 2 ** level
