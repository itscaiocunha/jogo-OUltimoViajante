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

# --- Diálogos da CENA 5 ---
var dialog_lines = [
	{"speaker": "VIAJANTE", "text": "Boa tarde, o médico me enviou — preciso preparar um remédio com urgência!"}, # 0
	{"speaker": "BOTICÁRIO", "text": "Estamos fechando, mas… se foi o doutor quem te enviou, entra.\nUse esta mesa — e cuidado com as proporções."}, # 1
	{"speaker": "NARRADOR", "text": "(Task de mistura dos ingredientes.)"}, # 2 (A Task)
	{"speaker": "VIAJANTE", "text": "Pronto! Acho que consegui."} # 3
]

var current_dialog_index = 0

func _ready():
	avancar_button.pressed.connect(func():
		if is_transitioning: return
		show_next_dialog_line()
	)
	
	set_process_unhandled_input(true)

	# Lógica de Retorno (para depois do Drag&Drop)
	if GameManager.resume_dialogue_index > 0:
		current_dialog_index = GameManager.resume_dialogue_index
		GameManager.resume_dialogue_index = 0
	
	start_scene()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if is_transitioning: return
		if current_dialog_index < dialog_lines.size(): 
			show_next_dialog_line()
		else:
			print("Diálogo finalizado, aguardando transição...")

func start_scene():
	viajante_sprite.modulate.a = 1.0
	boticario_sprite.modulate.a = 1.0
	fade_efeito.modulate.a = 0.0
	balao_fala.visible = false
	is_transitioning = false
	show_next_dialog_line()

func show_next_dialog_line():
	if current_dialog_index >= dialog_lines.size():
		hide_dialog_box()
		end_scene()
		return

	# Lógica da Task (Índice 2)
	if current_dialog_index == 2: 
		is_transitioning = true 
		hide_dialog_box()
		
		# 1. Diz ao GameManager para onde voltar (a próxima fala, índice 3)
		GameManager.resume_dialogue_index = 3 
		
		# 2. DIZ AO JOGO DE DRAG&DROP PARA VOLTAR AQUI (Cena 5)
		GameManager.minigame_return_scene = "res://Cena05_Boticario.tscn"
		
		# 3. Chama o fade e muda de cena
		fade_and_change_scene()
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

func fade_and_change_scene():
	var tween = create_tween()
	tween.tween_property(fade_efeito, "modulate:a", 1.0, 0.3) 
	await tween.finished 
	
	get_tree().change_scene_to_file("res://NivelReceita.tscn")

func hide_dialog_box():
	balao_fala.visible = false
	avancar_button.visible = false

func end_scene():
	is_transitioning = true
	set_process_unhandled_input(false) 
	GameManager.resume_dialogue_index = 0
	
	print("Cena 5 finalizada! Voltando para a vila JOGÁVEL...")
	
	if GameManager:
		GameManager.quest_status = "remedio_pronto" 
	
	get_tree().change_scene_to_file("res://vilarejo.tscn")
