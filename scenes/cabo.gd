extends Node2D

@onready var cabo1 = $Cabo1
@onready var cabo2 = $Cabo2

const VELOCIDADE_MOVIMENTO = 800
const DISTANCIA_LIMITE = 20

var unido = false
var pode_mover = false
var esta_arrastando = false

var no_para_mover: Sprite2D = cabo2

func _ready():
	set_process_input(true)
	
	# Verifica após o ready se a referência foi feita corretamente
	if not is_instance_valid(cabo2):
		print("ERRO CRÍTICO: O nó 'Cabo2' não foi encontrado. Verifique o nome na Árvore de Cena (case-sensitive).")
		return

func _process(delta):
	if unido or not pode_mover:
		return
	
	var alvo_pos = cabo1.global_position
	var pos_atual = no_para_mover.global_position
	
	var distancia = pos_atual.distance_to(alvo_pos)
	
	if distancia < DISTANCIA_LIMITE:
		no_para_mover.global_position = alvo_pos
		unido = true
		pode_mover = false
		print("Cabos unidos!")
	else:
		var direcao = (alvo_pos - pos_atual).normalized()
		var movimento = direcao * VELOCIDADE_MOVIMENTO * delta
		no_para_mover.global_position += movimento

func _input(event):
	if unido:
		return
	
	if not is_instance_valid(no_para_mover):
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not esta_arrastando and no_para_mover.get_global_rect().has_point(event.position):
				esta_arrastando = true
		else:
			if esta_arrastando:
				esta_arrastando = false
				pode_mover = true

	if esta_arrastando and event is InputEventMouseMotion:
		no_para_mover.global_position = event.position


func _on_cabo_1_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
