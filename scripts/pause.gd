extends Node2D

func _ready() -> void:
	$"../PauseMenu".hide()

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel") and global_variables.game_over == false:
		pause_unpause()

func pause_unpause() -> void:
		get_tree().paused = !get_tree().paused
		$"../PauseMenu".visible = !$"../PauseMenu".visible
