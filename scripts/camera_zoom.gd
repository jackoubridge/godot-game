extends Camera2D

var zoom_max = Vector2(1.3, 1.3)
var zoom_min = Vector2(0.4, 0.4)
var zoom_speed = Vector2(0.1, 0.1)
var desired_zoom = zoom

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	zoom = lerp(zoom, desired_zoom, .2)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if desired_zoom > zoom_min:
					desired_zoom -= zoom_speed
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if desired_zoom < zoom_max:
					desired_zoom += zoom_speed

	elif event is InputEventMagnifyGesture:
		if desired_zoom*event.factor < zoom_max and desired_zoom*event.factor > zoom_min:
			desired_zoom *= event.factor
					
