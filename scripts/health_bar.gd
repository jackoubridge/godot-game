extends Node2D

var fade_duration: float = 0.5
var value_smooth_duration: float = 0.05

var fade_tween: Tween
var value_tween: Tween

func _ready() -> void:
	$ProgressBar.visible = false
	$ProgressBar.min_value = 0.0
	$ProgressBar.max_value = 1.0
	$ProgressBar.step = 0.01

func update() -> void:
	if fade_tween:
		fade_tween.kill()
		fade_tween = null

	if value_tween:
		value_tween.kill()
		value_tween = null

	modulate.a = 1.0
	$ProgressBar.visible = true

	var target_value = get_parent().health / get_parent().health_max

	value_tween = create_tween()
	value_tween.tween_property($ProgressBar, "value", target_value, value_smooth_duration)

	$Timer.start()

func _on_timer_timeout() -> void:
	fade_tween = create_tween()
	fade_tween.tween_property($ProgressBar, "modulate:a", 0.0, fade_duration)

	await fade_tween.finished

	if modulate.a <= 0.0:
		$ProgressBar.visible = false

	fade_tween = null
