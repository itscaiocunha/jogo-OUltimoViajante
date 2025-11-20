extends Node2D

# Referências para os nós da cena
@onready var viajante_sprite = $ViajanteSprite
@onready var medico_sprite = $MedicoSprite

# Referências da UI (copiadas)
@onready var balao_fala = $UIScript/BalaoFala
@onready var nome_personagem_label = $UIScript/BalaoFala/NomePersonagemLabel
@onready var texto_dialogo_label = $UIScript/BalaoFala/TextoDialogoLabel
@onready var avancar_button = $UIScript/BalaoFala/AvancarButton

# --- Diálogos da CENA 4 ---
var dialog_lines = [
	{"speaker": "VIAJANTE", "text": "Com licença, o senhor é o médico de quem Hildegard falou?"},
	{"speaker": "MÉDICO", "text": "Sou, sim, médico por vocação, ainda que os tempos sejam ingratos.\nO que desejas, jovem?"},
	{"speaker": "VIAJANTE", "text": "Estou tentando ajudar os doentes — queria preparar um remédio, algo que alivie os sintomas."},
	{"speaker": "MÉDICO", "text": "Receio que não exista cura para tal flagelo…\nMas há um tônico que venho estudando: mistura de mel, vinagre e alho, mas falta o último ingrediente…"},
	{"speaker": "VIAJANTE", "text": "(pensando) Falta o último ingrediente… gengibre!"},
	{"speaker": "MÉDICO", "text": "Zingiber officinale? Inusitado… mas parece promissor!\nProcure o boticário, e peça que te empreste sua bancada.\nMas atenção: siga a ordem dos ingredientes à risca, qualquer erro será fatal."},
	{"speaker": "VIAJANTE", "text": "Pode deixar! Eu dou um jeito."}
]

var current_dialog_index = 0

func _ready():
	avancar_button.pressed.connect(show_next_dialog_line)
	set_process_unhandled_input(true)
	start_scene()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if current_dialog_index < dialog_lines.size(): 
			show_next_dialog_line()
		else:
			print("Diálogo finalizado, aguardando transição...")

func start_scene():
	viajante_sprite.modulate.a = 1.0
	medico_sprite.modulate.a = 1.0 # Certifique-se que o nó 'MedicoSprite' existe
	balao_fala.visible = false
	show_next_dialog_line()

func show_next_dialog_line():
	if current_dialog_index >= dialog_lines.size():
		hide_dialog_box()
		end_scene()
		return

	var line_data = dialog_lines[current_dialog_index]
	var speaker = line_data.speaker
	var text = line_data.text

	balao_fala.visible = true

	if speaker == "NARRADOR":
		nome_personagem_label.text = ""
	else:
		nome_personagem_label.text = speaker + ":"
	
	texto_dialogo_label.text = text
	current_dialog_index += 1


func hide_dialog_box():
	balao_fala.visible = false
	avancar_button.visible = false

func end_scene():
	set_process_unhandled_input(false) 
	
	print("Cena 4 finalizada! Voltando para a vila JOGÁVEL...")
	
	# Define a próxima missão
	if GameManager:
		GameManager.quest_status = "encontrar_boticario" 
	
	# Carrega a vila jogável
	get_tree().change_scene_to_file("res://vilarejo.tscn")
