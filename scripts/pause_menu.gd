extends CanvasLayer

func _on_resume_pressed() -> void:
	$"../PauseHandler".pause_unpause()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
