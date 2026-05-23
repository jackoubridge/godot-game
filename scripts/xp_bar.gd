extends ProgressBar

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	player.xp_update.connect(update_xp)
	player.level_update.connect(update_level)
	update_xp(player.xp)
	update_level(1)

func update_level(level: int):
	$Label.text = "Level " + str(level)

func update_xp(xp_value: int):
	value = xp_value
