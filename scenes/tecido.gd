extends Node2D

@onready var anim_sprite = $AnimatedSprite2D

var max_frames = 0
var is_dragging = false
var drag_start_position = Vector2.ZERO
var drag_threshold = 1000.0
var total_distance_dragged = 0.0

func _ready():
	if anim_sprite:
		var frames = anim_sprite.sprite_frames
		if frames:
			max_frames = frames.get_frame_count("default") 
			anim_sprite.frame = 0

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			is_dragging = true
			drag_start_position = event.position
		else:
			is_dragging = false
			drag_start_position = Vector2.ZERO
	
	elif event is InputEventMouse:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_dragging = true
				drag_start_position = event.position
			else:
				is_dragging = false
				drag_start_position = Vector2.ZERO

	if is_dragging and (event is InputEventMouseMotion or event is InputEventScreenDrag):
		var current_position = event.position
		var drag_distance_since_last_frame = current_position.distance_to(drag_start_position)
		
		total_distance_dragged += drag_distance_since_last_frame
		
		if total_distance_dragged >= drag_threshold:
			advance_frame()
			total_distance_dragged = 0.0
		
		drag_start_position = current_position

func advance_frame():
	if anim_sprite and max_frames > 0:
		if anim_sprite.frame < max_frames - 1:
			anim_sprite.frame += 1
