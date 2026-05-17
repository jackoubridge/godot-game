extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ProgressBar.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ($ProgressBar.value != 1 and $ProgressBar.visible == false):
		$ProgressBar.visible = true

func _physics_process(_delta: float) -> void:
	$ProgressBar.value = get_parent().health / get_parent().health_max
