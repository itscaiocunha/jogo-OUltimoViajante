extends Node2D

# --- Referências COMPLETAS para os nós da UI ---
@onready var balao_fala = $UIScript/BalaoFala
@onready var nome_personagem_label = $UIScript/BalaoFala/NomePersonagemLabel
@onready var texto_dialogo_label = $UIScript/BalaoFala/TextoDialogoLabel
@onready var avancar_button = $UIScript/BalaoFala/AvancarButton

# --- Referência para o efeito visual ---
@onready var monitor_portal = $UIScript/MonitorPortal 

# --- ADICIONE ESTA LINHA ---
@onready var portal_sfx_player = $PortalSFXPlayer

var dialog_lines = [
	{"speaker": "VIAJANTE", "text": "…Será que tudo isso foi um sonho?"},
	{"speaker": "NARRADOR", "text": "(A luz do monitor pisca — e, por um breve instante, um portal azul reluz na tela.)"}
]
var current_dialog_index = 0

func _ready():
	# Conecta os botões
	avancar_button.pressed.connect(show_next_dialog_line)
	set_process_unhandled_input(true)
	
	# Prepara a cena
	monitor_portal.visible = false
	balao_fala.visible = false
	
	# Começa o diálogo
	show_next_dialog_line()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if current_dialog_index < dialog_lines.size(): 
			show_next_dialog_line()

func show_next_dialog_line():
	# Se o diálogo terminou
	if current_dialog_index >= dialog_lines.size():
		# O jogo acabou. Volta para os Créditos.
		set_process_unhandled_input(false)
		get_tree().change_scene_to_file("res://CenaCreditos.tscn")
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
	
	# "A luz do monitor pisca..."
	if current_dialog_index == 1: 
		
		# --- ADICIONE ESTA LINHA ---
		# Toca o som do portal
		portal_sfx_player.play()
		# --------------------------

		# Ativa a animação do portal no monitor
		var tween = create_tween()
		tween.tween_property(monitor_portal, "visible", true, 0.0)
		tween.tween_interval(0.5) # Deixa o portal visível por 0.5s
		tween.tween_property(monitor_portal, "visible", false, 0.0)
	
	current_dialog_index += 1
