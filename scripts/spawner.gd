extends Node2D

@export var num_squares_threshold: int = 2
@export var num_triangles_threshold: int = 2

@export var square_scene: PackedScene
@export var triangle_scene: PackedScene
var squares: Array[Target] = []
var triangles: Array[Target] = []

func _ready() -> void:
	global_signals.target_destroyed.connect(_on_target_destroyed)
	$"../CharacterBody2D".level_update.connect(update_thresholds)

func _physics_process(_delta: float) -> void:
	if squares.size() < num_squares_threshold:
		spawn_target(square_scene)
	if triangles.size() < num_triangles_threshold:
		spawn_target(triangle_scene)

func spawn_target(target_path: PackedScene) -> void:

	var target: Target = target_path.instantiate()

	if (target.target_id == &"square"):
		squares.append(target)
	elif (target.target_id == &"triangle"):
		triangles.append(target)

	var random_x = randf_range(75, 300)
	var random_y = randf_range(75, 300)
	if randf() < 0.5:
		random_x *= -1
	if randf() < 0.5:
		random_y *= -1

	target.pos = Vector2(random_x, random_y) + $"../CharacterBody2D".global_position
	target.rot = randf_range(0, 2*PI)
	get_parent().get_parent().add_child(target)

func _on_target_destroyed(target: Target) -> void:
	if (target.target_id == &"square"):
		squares.erase(target)
	elif (target.target_id == &"triangle"):
		triangles.erase(target)

func update_thresholds(level: int) -> void:
	num_squares_threshold = min(2 ** level, 2 ** 5)
	num_triangles_threshold = min(2 ** level, 2 ** 5)
