extends Node2D

@export var recoil_offset: Vector2 = Vector2(-5, 0)

var rest_position: Vector2
var recoil_tween: Tween

func _ready():
	rest_position = position

func recoil():
	if recoil_tween:
		recoil_tween.kill()

	recoil_tween = create_tween()

	recoil_tween.tween_property(self, "position", rest_position + recoil_offset, 0.05)
	recoil_tween.tween_property(self, "position", rest_position, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
