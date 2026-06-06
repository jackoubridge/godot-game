extends CanvasLayer

signal upgrade_selected(stat_name: String)

func _ready() -> void:
	hide()

func upgrade_screen() -> String:
	get_tree().paused = true
	$"../PauseHandler".can_pause = false
	show()
	var stat: String = await upgrade_selected
	hide()
	get_tree().paused = false
	$"../PauseHandler".can_pause = true
	return stat

func _on_button_pressed(statToUpgrade: String) -> void:
	upgrade_selected.emit(statToUpgrade)
