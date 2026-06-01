extends CanvasLayer

func _ready() -> void:
	hide()

func gameOver(score: int) -> void:
	get_tree().paused = true
	$Control/Panel/MarginContainer/Score.text = "Score: " + str(score)
	show()

func _on_respawn_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
