extends Node2D

# --- Referências COMPLETAS para os nós da UI ---
@onready var balao_fala = $UIScript/BalaoFala
@onready var nome_personagem_label = $UIScript/BalaoFala/NomePersonagemLabel
@onready var texto_dialogo_label = $UIScript/BalaoFala/TextoDialogoLabel
@onready var avancar_button = $UIScript/BalaoFala/AvancarButton

# --- Referência para o efeito visual ---
@onready var monitor_portal = $UIScript/MonitorPortal 

# --- Som ---
@onready var portal_sfx_player = $PortalSFXPlayer
@onready var type_sfx_player = $TypeSFXPlayer  # <- coloque um AudioStreamPlayer2D para o som do typing

var dialog_lines = [
	{"speaker": "VIAJANTE", "text": "…Será que tudo isso foi um sonho?"},
	{"speaker": "NARRADOR", "text": "(A luz do monitor pisca — e, por um breve instante, um portal azul reluz na tela.)"}
]

var current_dialog_index = 0
var is_typing := false   # evita pular enquanto escreve

func _ready():
	avancar_button.pressed.connect(show_next_dialog_line)
	set_process_unhandled_input(true)

	monitor_portal.visible = false
	balao_fala.visible = false

	show_next_dialog_line()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if not is_typing:
			show_next_dialog_line()
		else:
			# Mostra texto completo se clicar durante a digitação
			is_typing = false

func show_next_dialog_line():
	if current_dialog_index >= dialog_lines.size():
		set_process_unhandled_input(false)
		get_tree().change_scene_to_file("res://cenas/CenaCreditos.tscn")
		return

	var line = dialog_lines[current_dialog_index]
	var speaker = line.speaker
	var text = line.text

	balao_fala.visible = true
	
	if speaker == "NARRADOR":
		nome_personagem_label.text = ""
	else:
		nome_personagem_label.text = speaker + ":"

	# Chama o typewriter
	await type_text(text)

	# Evento especial do portal
	if current_dialog_index == 1:
		portal_sfx_player.play()

		var tween = create_tween()
		tween.tween_property(monitor_portal, "visible", true, 0.0)
		tween.tween_interval(0.5)
		tween.tween_property(monitor_portal, "visible", false, 0.0)

	current_dialog_index += 1


# ============================================================
#               EFEITO DE DIGITAÇÃO (TYPEWRITER)
# ============================================================
func type_text(full_text: String) -> void:
	is_typing = true
	texto_dialogo_label.text = ""

	for i in full_text.length():
		if not is_typing:
			# Usuário clicou — mostra tudo na hora
			texto_dialogo_label.text = full_text
			break

		texto_dialogo_label.text += full_text[i]

		# toca o som a cada letra (se quiser diminuir, coloque um contador)
		if type_sfx_player:
			type_sfx_player.play()

		await get_tree().create_timer(0.02).timeout  # velocidade da digitação

	is_typing = false
