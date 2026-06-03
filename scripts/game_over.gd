extends CanvasLayer

@onready var color_rect := get_node("Control/ColorRect")
var game_over: bool = false

func _ready() -> void:
	hide()

func gameOver(score: int) -> void:
	if not game_over:
		game_over = true
		global_signals.game_over.emit()
		$Control/Panel/MarginContainer/Score.text = "Score: " + str(score)
		show()
		blur_background()
		slow_time()

func _on_respawn_pressed() -> void:
	Engine.time_scale = 1.0
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	Engine.time_scale = 1.0
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func slow_time() -> void:
	create_tween() \
		.set_ignore_time_scale(true) \
		.set_trans(Tween.TRANS_QUART) \
		.set_ease(Tween.EASE_OUT) \
		.tween_property(Engine, "time_scale", 0.1, 2.0)

func blur_background() -> void:
	var mat := color_rect.material as ShaderMaterial

	create_tween() \
		.set_ignore_time_scale(true) \
		.set_trans(Tween.TRANS_QUART) \
		.set_ease(Tween.EASE_OUT) \
		.tween_method(
			func(value):
				mat.set_shader_parameter("blur_amount", value),
			0.0,
			1.5,
			2.0
		)
