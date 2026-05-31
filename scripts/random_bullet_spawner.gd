extends Node2D

@export var bullet_path: PackedScene

var screen_size_x: float
var screen_size_y: float

func _ready() -> void:
	screen_size_x = get_viewport().get_visible_rect().size.x + 10
	screen_size_y = get_viewport().get_visible_rect().size.y + 10
	shoot()

func shoot() -> void:
	await get_tree().create_timer((randf()+0.5) * 2).timeout
	var spawn_pos: Vector2
	var edge = randi() % 4

	match edge:
		0: spawn_pos = Vector2(randf_range(0, screen_size_x), -10)
		1: spawn_pos = Vector2(randf_range(0, screen_size_x), screen_size_y)
		2: spawn_pos = Vector2(-10, randf_range(0, screen_size_y))
		3: spawn_pos = Vector2(screen_size_x, randf_range(0, screen_size_y))

	var bullet = bullet_path.instantiate()

	bullet.owner_node = null
	bullet.pos = spawn_pos
	bullet.dir = (Vector2(screen_size_x/2, screen_size_y/2) - bullet.pos).angle()
	bullet.rot = 0
	bullet.speed = 300
	bullet.damage = 5

	$"..".add_child(bullet)
	shoot()
