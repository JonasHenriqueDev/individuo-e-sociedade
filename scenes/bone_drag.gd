extends Node2D

var selected = false
var mouse_offset = Vector2(0, 0)

func _process(delta):
	if selected:
		followMouse()

func followMouse():
	position = get_global_mouse_position() + mouse_offset

func _on_area_2d_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			mouse_offset = position - get_global_mouse_position()
			selected = true
		else:
			selected = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "TrashArea":
			queue_free()
