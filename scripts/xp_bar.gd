extends ProgressBar

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.xp_update.connect(update_xp)
	player.level_update.connect(update_level)
	update_xp(player.xp, player.level_up_xp)
	update_level(1)

func update_level(level: int) -> void:
	$Label.text = "Level " + str(level)

func update_xp(xp_value: int, level_up_xp: int) -> void:
	value = xp_value
	max_value = level_up_xp
