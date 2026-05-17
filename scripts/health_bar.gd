extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ($ProgressBar.value == 1):
		$ProgressBar.visible = false
	else:
		$ProgressBar.visible = true
		
	$ProgressBar.value = lerp($ProgressBar.value, get_parent().health / get_parent().health_max, 25*delta)

func _physics_process(_delta: float) -> void:
	pass
