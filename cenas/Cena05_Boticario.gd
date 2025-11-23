extends Node2D

# Referências para os nós da cena
@onready var viajante_sprite = $ViajanteSprite
@onready var boticario_sprite = $BoticarioSprite
@onready var fade_efeito = $FadeEfeito 

# Referências da UI
@onready var balao_fala = $UIScript/BalaoFala
@onready var nome_personagem_label = $UIScript/BalaoFala/NomePersonagemLabel
@onready var texto_dialogo_label = $UIScript/BalaoFala/TextoDialogoLabel
@onready var avancar_button = $UIScript/BalaoFala/AvancarButton

var is_transitioning = false
var typing := false
var type_speed := 0.03

# Diálogos da CENA 5
var dialog_lines = [
	{"speaker": "VIAJANTE", "text": "Boa tarde, o médico me enviou! preciso preparar um remédio com urgência!"},
	{"speaker": "BOTICÁRIO", "text": "Estamos fechando, mas… se foi o doutor quem te enviou, entra.\nUse esta mesa — e cuidado com as proporções."},
	{"speaker": "NARRADOR", "text": "(Task de mistura dos ingredientes.)"},
	{"speaker": "VIAJANTE", "text": "Pronto! Acho que consegui."}
]

var current_dialog_index = 0

func _ready():
	avancar_button.pressed.connect(func():
		if typing:
			skip_typewriter()
			return
		if is_transitioning: return
		show_next_dialog_line()
	)
	
	set_process_unhandled_input(true)

	if GameManager.resume_dialogue_index > 0:
		current_dialog_index = GameManager.resume_dialogue_index
		GameManager.resume_dialogue_index = 0
	
	start_scene()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if is_transitioning: return

		if typing:
			skip_typewriter()
		else:
			show_next_dialog_line()

func start_scene():
	viajante_sprite.modulate.a = 1.0
	boticario_sprite.modulate.a = 1.0
	fade_efeito.modulate.a = 0.0
	balao_fala.visible = false
	is_transitioning = false
	show_next_dialog_line()

# -------------------------------------------------------
# TYPEWRITER
# -------------------------------------------------------
func typewriter(text: String) -> void:
	typing = true

	# 🔥 IMPORTANTE: definir o texto ANTES de usar visible_characters
	texto_dialogo_label.text = text
	texto_dialogo_label.visible_characters = 0

	for i in range(text.length()):
		if not typing:
			# 🔥 IMPORTANTE: força mostrar tudo
			texto_dialogo_label.visible_characters = text.length()
			return

		texto_dialogo_label.visible_characters = i + 1
		await get_tree().create_timer(type_speed).timeout

	typing = false

func skip_typewriter():
	typing = false
	texto_dialogo_label.visible_characters = texto_dialogo_label.text.length()

# -------------------------------------------------------
# DIÁLOGO
# -------------------------------------------------------
func show_next_dialog_line():
	if typing: return

	if current_dialog_index >= dialog_lines.size():
		hide_dialog_box()
		end_scene()
		return

	# Task de mistura (índice 2)
	if current_dialog_index == 2:
		is_transitioning = true
		hide_dialog_box()

		GameManager.resume_dialogue_index = 3
		GameManager.minigame_return_scene = "res://cenas/Cena05_Boticario.tscn"

		fade_and_change_scene()
		return

	var line = dialog_lines[current_dialog_index]
	current_dialog_index += 1

	balao_fala.visible = true
	avancar_button.visible = true

	if line.speaker == "NARRADOR":
		nome_personagem_label.text = ""
	else:
		nome_personagem_label.text = line.speaker + ":"

	# 🔥 IMPORTANTE: REMOVIDO “texto_dialogo_label.text = line.text”
	# Agora o typewriter controla todo o texto

	await typewriter(line.text)

func fade_and_change_scene():
	var tween = create_tween()
	tween.tween_property(fade_efeito, "modulate:a", 1.0, 0.3)
	await tween.finished
	
	LevelLoader.carregar_cena("res://levels/NivelReceita.tscn")

func hide_dialog_box():
	balao_fala.visible = false
	avancar_button.visible = false

func end_scene():
	is_transitioning = true
	set_process_unhandled_input(false)

	GameManager.resume_dialogue_index = 0
	GameManager.quest_status = "remedio_pronto"

	LevelLoader.carregar_cena("res://levels/vilarejo.tscn")
