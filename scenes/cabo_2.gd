extends Node2D

var touch_index = -1
var mouse_offset = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO
var x_clamp_min = 245
var x_clamp_max = 530
var is_connected = false # Adicionado

func _ready():
	if start_position == Vector2.ZERO:
		start_position = position

func _input(event):
	if is_connected: # Trava adicionada
		return
		
	if event is InputEventScreenDrag and event.index == touch_index:
		var mouse = get_global_mouse_position_from_event(event) + mouse_offset
		position.x = clamp(mouse.x, x_clamp_min, x_clamp_max)

	elif event is InputEventMouseMotion and touch_index == 0:
		var mouse = get_global_mouse_position_from_event(event) + mouse_offset
		position.x = clamp(mouse.x, x_clamp_min, x_clamp_max)

	elif event is InputEventScreenTouch and not event.pressed and event.index == touch_index:
		touch_index = -1
		voltar_para_inicio()

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and touch_index == 0:
		touch_index = -1
		voltar_para_inicio()

func get_global_mouse_position_from_event(event):
	return get_viewport().get_canvas_transform().affine_inverse() * event.position

func _on_area_2d_input_event(viewport, event, shape_idx):
	if is_connected: # Trava adicionada
		return
		
	if event is InputEventScreenTouch and event.pressed:
		if touch_index == -1:
			touch_index = event.index
			mouse_offset = position - get_global_mouse_position_from_event(event)
	
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if touch_index == -1:
			touch_index = 0 
			mouse_offset = position - get_global_mouse_position_from_event(event)
			
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Cabo1Area":
		
		# Novo: Define a conexão, desliga o arrasto e trava o cabo na posição
		is_connected = true
		touch_index = -1
		position.x = x_clamp_min



func voltar_para_inicio():
	var tween = create_tween()
	tween.tween_property(self, "position", start_position, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
