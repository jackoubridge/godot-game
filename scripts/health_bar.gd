extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ProgressBar.visible = false	

func _on_target_health_update() -> void:
	if ($ProgressBar.visible == false):
		$ProgressBar.visible = true
	$ProgressBar.value = get_parent().health / get_parent().health_max
