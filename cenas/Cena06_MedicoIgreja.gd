extends Node2D

# --- CORREÇÃO AQUI: Adicionamos as @onready vars que faltavam ---
@onready var viajante_sprite = $ViajanteSprite
@onready var medico_sprite = $MedicoSprite
@onready var balao_fala = $UIScript/BalaoFala
@onready var nome_personagem_label = $UIScript/BalaoFala/NomePersonagemLabel
@onready var texto_dialogo_label = $UIScript/BalaoFala/TextoDialogoLabel
@onready var avancar_button = $UIScript/BalaoFala/AvancarButton
# -----------------------------------------------------------------

var dialog_lines = [
	{"speaker": "MÉDICO", "text": "Excelente, rapaz! Usarei o tônico nos enfermos imediatamente.\nFizeste mais por este povo do que muitos nobres."},
	{"speaker": "VIAJANTE", "text": "Ainda falta eliminar a causa. Vou até a rua principal… preciso dar um fim nos ratos."},
	{"speaker": "MÉDICO", "text": "Que os céus te protejam, jovem destemido!"},
	{"speaker": "NARRADOR", "text": "(Task final: eliminar ratos.)"}
]

var current_dialog_index = 0

func _ready():
	# Agora o 'avancar_button' existe e esta linha funcionará
	avancar_button.pressed.connect(show_next_dialog_line)
	set_process_unhandled_input(true)
	start_scene()

# --- FUNÇÃO QUE FALTAVA ---
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if current_dialog_index < dialog_lines.size(): 
			show_next_dialog_line()
# ----------------------------

func start_scene():
	viajante_sprite.modulate.a = 1.0
	medico_sprite.modulate.a = 1.0
	balao_fala.visible = false
	show_next_dialog_line()

func show_next_dialog_line():
	# Se o diálogo terminou, chama a função de finalização
	if current_dialog_index >= dialog_lines.size():
		end_scene()
		return
		
	# Lógica da Task (Índice 3)
	if current_dialog_index == 3: 
		hide_dialog_box()
		
		# Define a próxima quest
		if GameManager:
			GameManager.quest_status = "eliminar_ratos"
			
		# Carrega a cena da task
		# (Certifique-se que o caminho está correto!)
		get_tree().change_scene_to_file("res://levels/NivelEliminarRatos.tscn") 
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

# --- FUNÇÕES QUE FALTAVAM ---
func hide_dialog_box():
	balao_fala.visible = false
	avancar_button.visible = false

func end_scene():
	# Esta cena não volta para a vila, ela vai para a task
	set_process_unhandled_input(false)
# ----------------------------
