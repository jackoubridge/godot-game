extends Node2D

var num_squares: int = 0
@export var num_squares_threshold: int = 5

var num_triangles: int = 0
@export var num_triangles_threshold: int = 5

var square_path = preload("res://scenes/square.tscn")
var triangle_path = preload("res://scenes/triangle.tscn")
var player_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_signals.target_destroyed.connect(_on_target_destroyed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	if num_squares < num_squares_threshold:
		spawn_target("square")
	if num_triangles < num_triangles_threshold:
		spawn_target("triangle")

func spawn_target(type):
	var target

	if (type == "square"):
		target = square_path.instantiate()
		num_squares += 1
	elif (type == "triangle"):
		target = triangle_path.instantiate()
		num_triangles += 1

	var random_x = randf_range(75, 300)
	var random_y = randf_range(75, 300)
	if randf() < 0.5:
		random_x *= -1
	if randf() < 0.5:
		random_y *= -1

	target.pos = Vector2(random_x, random_y) + $"../CharacterBody2D".position
	target.rot = randf_range(0, 2*PI)
	get_parent().get_parent().add_child(target)

func _on_target_destroyed(type):
	if (type == "square"):
		num_squares -= 1
	elif (type == "triangle"):
		num_triangles -= 1
