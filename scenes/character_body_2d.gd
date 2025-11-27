extends CharacterBody2D

const SPEED = 300.0
const ACCEL_SENSITIVITY = 1500.0

var can_move: bool = true
# Defina a posição inicial (ajuste esses valores para o ponto de spawn do seu labirinto)
const START_POSITION = Vector2(11, 107)

@onready var message = $"../MazeNode/TextBox2/Message"
@onready var panel = $"../MazeNode/TextBox2"

func _ready():
	Input.use_accumulated_input = false
	message.visible = false
	panel.visible = false
	global_position = START_POSITION # Define a posição inicial na execução
func _physics_process(delta):
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var ui_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var ui_velocity = ui_direction * SPEED
	
	var accel_input = Input.get_accelerometer()
	var accel_velocity = Vector2.ZERO
	
	if accel_input:
		var accel_direction = Vector2.ZERO
		accel_direction.x = accel_input.x
		accel_direction.y = -accel_input.y
		
		accel_velocity = accel_direction * ACCEL_SENSITIVITY * delta
	
	var total_velocity = ui_velocity + accel_velocity
	
	if total_velocity.length() > SPEED:
		total_velocity = total_velocity.normalized() * SPEED
		
	velocity = total_velocity
	move_and_slide()


func _on_area_2d_familia_body_entered(body: Node) -> void:
	if body != self:
		return
	can_move = false
	message.text = "VOCÊ ESCOLHEU TER UMA FAMÍLIA"
	message.visible = true
	panel.visible = true
func _on_area_2d_viagens_body_entered(body: Node) -> void:
	if body != self:
		return
	can_move = false
	message.text = "VOCÊ ESCOLHEU SER UM VIAJANTE"
	message.visible = true
	panel.visible = true

func _on_area_2d_carreira_body_entered(body: Node) -> void:
	if body != self:
		return
	can_move = false
	message.text = "VOCÊ ESCOLHEU FOCAR NA SUA CARREIRA"
	message.visible = true
	panel.visible = true

func _on_ok_button_pressed() -> void:
	can_move = true
	message.visible = false
	panel.visible = false
	global_position = START_POSITION
