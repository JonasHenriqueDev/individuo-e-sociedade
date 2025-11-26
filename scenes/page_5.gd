extends Control

var active_touches = {}
var initial_drag_pos = {} 

var cable1_node
var cable2_node
var is_pinching = false

const CONNECTION_DISTANCE_SQ = 2500

func _ready():
	cable1_node = $Background/Cabo1
	cable2_node = $Background/Cabo2
	
	set_process_input(true)

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		
		var target_cable = null
		
		if cable1_node and cable1_node.get_global_rect().has_point(event.position):
			target_cable = cable1_node
		
		elif cable2_node and cable2_node.get_global_rect().has_point(event.position):
			target_cable = cable2_node
			
		if target_cable:
			_handle_touch_event(event, target_cable)

func _handle_touch_event(event, cable):
	if event is InputEventScreenTouch:
		if event.pressed:
			active_touches[event.index] = event.position
			initial_drag_pos[event.index] = cable.global_position - event.position
		else:
			if active_touches.has(event.index):
				active_touches.erase(event.index)
				initial_drag_pos.erase(event.index)
		
		_update_pinching_state()
		get_tree().set_input_as_handled()
		
	elif event is InputEventScreenDrag:
		if active_touches.has(event.index):
			active_touches[event.index] = event.position
		
		if is_pinching:
			_handle_pinch()
		else:
			_handle_drag(event.index, cable)
			
		get_tree().set_input_as_handled()

func _update_pinching_state():
	is_pinching = active_touches.size() >= 2

func _handle_drag(touch_index, cable):
	if cable and initial_drag_pos.has(touch_index):
		cable.global_position = active_touches[touch_index] + initial_drag_pos[touch_index]
	
	_check_connection()

func _handle_pinch():
	var indices = active_touches.keys()
	if indices.size() < 2:
		return
		
	var pos1 = active_touches[indices[0]]
	var pos2 = active_touches[indices[1]]
	
	var distance_sq = pos1.distance_squared_to(pos2)
	
	if distance_sq < CONNECTION_DISTANCE_SQ:
		print("CONEXÃO DETECTADA POR PINÇA!")
		cable2_node.global_position = cable1_node.global_position
		# Sua função de conexão final deve ser chamada aqui
		
	_check_connection()

func _check_connection():
	if cable1_node and cable2_node:
		var distance_sq = cable1_node.global_position.distance_squared_to(cable2_node.global_position)
		if distance_sq < CONNECTION_DISTANCE_SQ:
			# Sua função de conexão final deve ser chamada aqui também
			pass
