extends Control # Ou Node2D, o que for o nó raiz da sua página

# Certifique-se de que os nomes correspondem aos nós na sua cena
@onready var narration_player = $NarrationPlayer 
@onready var video_player = $Background/DominoVideo 

var narration_bus_index = -1
var video_bus_index = -1

func _ready():
	narration_bus_index = AudioServer.get_bus_index("Narration")
	video_bus_index = AudioServer.get_bus_index("Video")
	
	# Inicializa a atribuição dos players aos buses corretos
	if narration_player:
		narration_player.bus = "Narration"
	if video_player:
		video_player.bus = "Video"
	
	# Estado Inicial: Vídeo MUTE/PAUSADO e Narração UNMUTE/PRONTA
	_set_bus_mute_state(video_bus_index, true)
	_set_bus_mute_state(narration_bus_index, false)

# Ação ao Iniciar/Parar o Vídeo
func _process(delta):
	if video_player and narration_bus_index != -1 and video_bus_index != -1:
		
		# Vídeo está tocando: Habilitar Áudio do Vídeo (Bus Video) e MUTE Narração
		if video_player.is_playing():
			_set_bus_mute_state(video_bus_index, false)
			_set_bus_mute_state(narration_bus_index, true)
			# Garante que a narração pare imediatamente se estiver tocando
			narration_player.stop() 
		
		# Vídeo NÃO está tocando (Parado ou Pausado): Habilitar Narração e MUTE Vídeo
		else:
			_set_bus_mute_state(video_bus_index, true)
			_set_bus_mute_state(narration_bus_index, false)

func _set_bus_mute_state(bus_index: int, mute: bool):
	if bus_index != -1:
		AudioServer.set_bus_mute(bus_index, mute)
