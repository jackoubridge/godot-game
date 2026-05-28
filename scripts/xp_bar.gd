extends ProgressBar

var value_tween: Tween
var value_smooth_duration: float = 0.1

func _ready() -> void:
	min_value = 0.0
	max_value = 1.0
	step = 0.01

	var player = get_tree().get_first_node_in_group("player")
	player.xp_update.connect(update_xp)
	player.level_update.connect(update_level)
	update_xp(player.xp, player.level_up_xp)
	update_level(1)

func update_level(level: int) -> void:
	$Label.text = "Level " + str(level)

func update_xp(xp_value: int, level_up_xp: int) -> void:
	if value_tween:
		value_tween.kill()
		value_tween = null

	value_tween = create_tween()
	value_tween.tween_property(self, "value", (float(xp_value)/float(level_up_xp)), value_smooth_duration)
