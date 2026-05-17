extends Node2D

var num_squares: int = 0

var square_path = preload("res://scenes/square.tscn")
var player_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_signals.square_destroyed.connect(_on_square_destroyed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	if num_squares == 0:
		spawn_square()

func spawn_square():
	var square = square_path.instantiate()

	var random_x = randf_range(100, 200)
	var random_y = randf_range(100, 200)
	if randf() < 0.5:
		random_x *= -1
	if randf() < 0.5:
		random_y *= -1

	square.pos = Vector2(random_x, random_y) + $"../CharacterBody2D".position
	square.rot = randf_range(0, 2*PI)
	get_parent().get_parent().add_child(square)
	num_squares += 1
	
func _on_square_destroyed():
	num_squares -= 1
