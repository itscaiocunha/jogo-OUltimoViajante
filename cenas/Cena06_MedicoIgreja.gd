extends Node2D

@onready var viajante_sprite = $ViajanteSprite
@onready var medico_sprite = $MedicoSprite
@onready var balao_fala = $UIScript/BalaoFala
@onready var nome_personagem_label = $UIScript/BalaoFala/NomePersonagemLabel
@onready var texto_dialogo_label = $UIScript/BalaoFala/TextoDialogoLabel
@onready var avancar_button = $UIScript/BalaoFala/AvancarButton

var dialog_lines = [
	{"speaker": "MÉDICO", "text": "Excelente, rapaz! Usarei o tônico nos enfermos imediatamente.\nFizeste mais por este povo do que muitos nobres."},
	{"speaker": "VIAJANTE", "text": "Ainda falta eliminar a causa. Vou até a rua principal… preciso dar um fim nos ratos."},
	{"speaker": "MÉDICO", "text": "Que os céus te protejam, jovem destemido!"},
	{"speaker": "NARRADOR", "text": "(Task final: eliminar ratos.)"}
]

var current_dialog_index = 0
var typing = false
var full_text = ""
var letter_index = 0
var type_speed := 0.02  # velocidade do efeito

func _ready():
	avancar_button.pressed.connect(_on_next_pressed)
	set_process_unhandled_input(true)
	start_scene()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		_on_next_pressed()

func _on_next_pressed():
	if typing:
		# se o texto ainda está sendo escrito, pula direto para o final
		texto_dialogo_label.text = full_text
		typing = false
		return

	show_next_dialog_line()

func start_scene():
	balao_fala.visible = false
	show_next_dialog_line()

func show_next_dialog_line():
	if current_dialog_index >= dialog_lines.size():
		end_scene()
		return
	
	if current_dialog_index == 3: 
		hide_dialog_box()
		if GameManager:
			GameManager.quest_status = "eliminar_ratos"
		LevelLoader.carregar_cena("res://levels/NivelEliminarRatos.tscn") 
		return 

	var line_data = dialog_lines[current_dialog_index]
	var speaker = line_data.speaker
	full_text = line_data.text

	balao_fala.visible = true

	if speaker == "NARRADOR":
		nome_personagem_label.text = ""
	else:
		nome_personagem_label.text = speaker + ":"

	# inicia o efeito de escrever
	start_typewriter(full_text)

	current_dialog_index += 1

func start_typewriter(text):
	typing = true
	letter_index = 0
	texto_dialogo_label.text = ""

	# inicia o processamento do efeito
	set_process(true)

func _process(delta):
	if typing:
		letter_index += 1

		if letter_index <= full_text.length():
			texto_dialogo_label.text = full_text.substr(0, letter_index)
		else:
			typing = false
			set_process(false)  # para otimizar
		

func hide_dialog_box():
	balao_fala.visible = false
	avancar_button.visible = false

func end_scene():
	set_process_unhandled_input(false)
