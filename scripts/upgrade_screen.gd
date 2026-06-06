extends CanvasLayer

signal upgrade_selected(stat_name: String)
var time_tween

func _ready() -> void:
	hide()

func upgrade_screen() -> String:

	set_timescale(0.0, Tween.EASE_OUT)
	await time_tween.finished

	get_tree().paused = true
	$"../PauseHandler".can_pause = false
	show()
	var stat: String = await upgrade_selected
	hide()
	get_tree().paused = false
	$"../PauseHandler".can_pause = true

	set_timescale(1.0, Tween.EASE_IN)
	await time_tween.finished

	return stat

func _on_button_pressed(statToUpgrade: String) -> void:
	upgrade_selected.emit(statToUpgrade)

func set_timescale(value: float, ease_type: Tween.EaseType) -> void:
	time_tween = create_tween() \
		.set_ignore_time_scale(true) \
		.set_trans(Tween.TRANS_QUART) \
		.set_ease(ease_type) \
		.tween_property(Engine, "time_scale", value, 0.75)
