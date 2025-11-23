extends Node2D

@onready var viajante_sprite = $ViajanteSprite
@onready var hildegard_sprite = $HildegardSprite
@onready var bruxo_sprite = $BruxoSprite
@onready var balao_fala = $UIScript/BalaoFala
@onready var nome_personagem_label = $UIScript/BalaoFala/NomePersonagemLabel
@onready var texto_dialogo_label = $UIScript/BalaoFala/TextoDialogoLabel
@onready var avancar_button = $UIScript/BalaoFala/AvancarButton
@onready var clarao_fundo = $ClaraoFundo

@onready var typing_sound = $UIScript/BalaoFala/SomDigitar

var dialog_lines = [
	{"speaker": "VIAJANTE", "text": "Acredito que não precisarás mais partir. A praga está controlada."},
	{"speaker": "HILDEGARD", "text": "Bendito sejas, senhor! És um enviado dos céus!"},
	{"speaker": "BRUXO", "text": "Aí está você, viajante! Consertei o aparelho, mas ele está instável.\nSe não formos agora, ficarás preso neste tempo para sempre!"},
	{"speaker": "VIAJANTE", "text": "Espere — preciso me despedir."},
	{"speaker": "HILDEGARD", "text": "Vá, jovem senhor. Que os deuses te guardem."},
	{"speaker": "VIAJANTE", "text": "Adeus… e boa sorte."},
	{"speaker": "NARRADOR", "text": "(Um clarão azul. O viajante desperta sobre os livros, no quarto.)"}
]

var current_dialog_index = 0
var is_typing := false
var type_speed := 0.02

func _ready():
	if GameManager.attempt_count > 1:
		dialog_lines.remove_at(5)
		
	avancar_button.pressed.connect(show_next_dialog_line)
	set_process_unhandled_input(true)
	start_scene()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if is_typing:
			finish_typewriter()
		else:
			show_next_dialog_line()

func start_scene():
	viajante_sprite.modulate.a = 1.0
	hildegard_sprite.modulate.a = 1.0
	bruxo_sprite.modulate.a = 0.0	
	balao_fala.visible = false
	show_next_dialog_line()

func show_next_dialog_line():
	if is_typing:
		return
	
	if current_dialog_index >= dialog_lines.size():
		return

	if current_dialog_index == dialog_lines.size() - 1:
		hide_dialog_box()
		
		var line_data = dialog_lines[current_dialog_index]
		balao_fala.visible = true
		nome_personagem_label.text = ""
		await typewriter(line_data.text)
		
		var tween = create_tween()
		tween.tween_interval(1.5)
		tween.tween_property(clarao_fundo, "visible", true, 0.0)
		tween.tween_property(clarao_fundo, "modulate:a", 1.0, 0.2)
		tween.tween_callback(end_scene)
		
		current_dialog_index += 1
		return

	var line_data = dialog_lines[current_dialog_index]
	var speaker = line_data.speaker
	var text = line_data.text

	balao_fala.visible = true

	if speaker == "NARRADOR":
		nome_personagem_label.text = ""
	else:
		nome_personagem_label.text = speaker + ":"
	
	await typewriter(text)

	if speaker == "BRUXO" and bruxo_sprite.modulate.a == 0.0:
		var tween = create_tween()
		tween.tween_property(bruxo_sprite, "modulate:a", 1.0, 0.5)

	current_dialog_index += 1

func typewriter(text):
	is_typing = true
	
	# CORREÇÃO AQUI
	texto_dialogo_label.text = text
	texto_dialogo_label.visible_characters = 0

	var length = text.length()

	for i in range(length):
		if not is_typing:
			break
		texto_dialogo_label.visible_characters = i + 1
		if typing_sound:
			typing_sound.play()
		await get_tree().create_timer(type_speed).timeout

	is_typing = false


func finish_typewriter():
	is_typing = false
	texto_dialogo_label.visible_characters = texto_dialogo_label.text.length()

func hide_dialog_box():
	balao_fala.visible = false
	avancar_button.visible = false

func end_scene():
	set_process_unhandled_input(false)
	LevelLoader.carregar_cena("res://cenas/Cena08_QuartoFinal.tscn")
