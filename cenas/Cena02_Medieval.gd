extends Node2D

# Referências para os nós da cena
@onready var viajante_sprite = $ViajanteSprite
@onready var bruxo_sprite = $BruxoSprite
@onready var fagulhas_sprite = $FagulhasSprite

# Referências da UI
@onready var balao_fala = $UIScript/BalaoFala
@onready var nome_personagem_label = $UIScript/BalaoFala/NomePersonagemLabel
@onready var texto_dialogo_label = $UIScript/BalaoFala/TextoDialogoLabel
@onready var avancar_button = $UIScript/BalaoFala/AvancarButton

# --- Diálogos da CENA 2 ---
var dialog_lines = [
	{"speaker": "VIAJANTE", "text": "AAAAAAAH!"},
	{"speaker": "BRUXO", "text": "Eu lhe disse que não me deixastes escolha."},
	{"speaker": "VIAJANTE", "text": "Você é maluco! Quer dinheiro? Eu sou universitário, não tenho um tostão furado!"},
	{"speaker": "BRUXO", "text": "Dinheiro? Ora, por Deus, achas mesmo que uma entidade como eu precisa de tua moeda?\nPreciso da tua ajuda!"},
	{"speaker": "VIAJANTE", "text": "Ah ótimo, e sequestrando gente é assim que você pede?"},
	{"speaker": "BRUXO", "text": "O dispositivo te escolheu, rapaz. Só tu podes ajudar este povo.\nMas… droga! Usei as últimas energias do aparelho. Se não o consertar logo, ficaremos presos nesta era!"},
	{"speaker": "VIAJANTE", "text": "Presos?! Eu tenho prova amanhã! Acha que a faculdade aceita atestado de viagem temporal forçada?!"},
	{"speaker": "BRUXO", "text": "Silêncio! Escute-me bem: procure Hildegard, uma jovem que carrega uma galinha sobre a cabeça.\nEla te auxiliará."},
	{"speaker": "VIAJANTE", "text": "…Se eu contar que faltei a prova porque fui raptado por um viajante do tempo, nem a Mary Angel acredita.\nMas se essa tal Hildegard é minha única pista… melhor ir logo."}
]

var current_dialog_index = 0
var is_typing := false
var typing_speed := 0.03


func _ready():
	avancar_button.pressed.connect(show_next_dialog_line)
	set_process_unhandled_input(true)
	start_scene()


func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if is_typing:
			# pula direto pro texto completo
			is_typing = false
			texto_dialogo_label.text = dialog_lines[current_dialog_index]["text"]
			return
		
		if current_dialog_index < dialog_lines.size(): 
			show_next_dialog_line()
		else:
			print("Diálogo finalizado, aguardando transição...")


func start_scene():
	viajante_sprite.modulate.a = 1.0
	bruxo_sprite.modulate.a = 1.0	
	balao_fala.visible = false

	show_next_dialog_line()


# ------------------------------------------------------------
# TYPEWRITER (SEM SOM)
# ------------------------------------------------------------
func typewriter_text(full_text: String) -> void:
	is_typing = true
	texto_dialogo_label.text = ""

	for i in full_text.length():
		if not is_typing:
			# caso o jogador tenha pulado
			texto_dialogo_label.text = full_text
			return
		
		texto_dialogo_label.text += full_text[i]
		await get_tree().create_timer(typing_speed).timeout

	is_typing = false


# ------------------------------------------------------------
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

	# Mostra texto digitando
	await typewriter_text(text)

	# -------------------------
	# EVENTOS VISUAIS
	# -------------------------

	# (nada especial aqui na Cena 2 até a fala 8)

	current_dialog_index += 1


func hide_dialog_box():
	balao_fala.visible = false
	avancar_button.visible = false


func end_scene():
	set_process_unhandled_input(false) 
	print("Cena 2 finalizada! Carregando a vila JOGÁVEL...")
	LevelLoader.carregar_cena("res://levels/vilarejo.tscn")
