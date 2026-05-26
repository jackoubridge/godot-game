extends Node2D

func _ready() -> void:
	$ProgressBar.visible = false

func update() -> void:
	if ($ProgressBar.visible == false):
		$ProgressBar.visible = true
	$ProgressBar.value = get_parent().health / get_parent().health_max
