extends Node2D

var can_pause: bool = true

func _ready() -> void:
	global_signals.game_over.connect(_on_game_over)
	$"../PauseMenu".hide()

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel") and can_pause == true:
		pause_unpause()

func pause_unpause() -> void:
		get_tree().paused = !get_tree().paused
		$"../PauseMenu".visible = !$"../PauseMenu".visible

func _on_game_over() -> void:
	can_pause = false
