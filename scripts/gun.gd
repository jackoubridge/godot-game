extends Node2D

@export var recoil_offset: Vector2 = Vector2(-5, 0)

var rest_position: Vector2
var recoil_tween: Tween

var can_shoot: bool = true
var game_over: bool = false

@export var player: Node2D
@export var bullet_path: PackedScene

func _ready() -> void:
	rest_position = position

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot() -> void:
	if can_shoot and not global_variables.game_over:
		# Handle shoot cooldown
		can_shoot = false
		$Timer.start(player.shoot_cooldown)

		# Spawn bullet
		var bullet = bullet_path.instantiate()

		bullet.owner_node = player
		bullet.pos = $BulletStart.global_position
		bullet.dir = get_parent().rotation
		bullet.rot = get_parent().global_rotation
		bullet.speed = player.bullet_speed
		bullet.damage = player.bullet_damage

		player.add_child(bullet)

		# Play gun recoil animation
		recoil()

func recoil() -> void:
	if recoil_tween:
		recoil_tween.kill()

	recoil_tween = create_tween()

	recoil_tween.tween_property(self, "position", rest_position + recoil_offset, 0.05)
	recoil_tween.tween_property(self, "position", rest_position, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	get_parent().knockback(player.recoil_strength)

# Handle shoot cooldown
func _on_timer_timeout() -> void:
	can_shoot = true
