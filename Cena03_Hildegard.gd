extends Node2D

# Referências para os nós da cena
@onready var viajante_sprite = $ViajanteSprite
@onready var hildegard_sprite = $HildegardSprite
@onready var fade_efeito = $FadeEfeito 

# Referências da UI
@onready var balao_fala = $UIScript/BalaoFala
@onready var nome_personagem_label = $UIScript/BalaoFala/NomePersonagemLabel
@onready var texto_dialogo_label = $UIScript/BalaoFala/TextoDialogoLabel
@onready var avancar_button = $UIScript/BalaoFala/AvancarButton

var is_transitioning = false

# --- Diálogos da CENA 3 ---
# (Certifique-se que sua lista de diálogos está completa aqui)
var dialog_lines = [
	{"speaker": "VIAJANTE", "text": "Com licença… você é a Hildegard?"}, # 0
	{"speaker": "HILDEGARD", "text": "Sou eu mesma. Que desejas, forasteiro?"}, # 1
	{"speaker": "VIAJANTE", "text": "Então… um homem meio esquisito, com um relógio de bolso, pediu pra eu te procurar. Disse algo sobre um… diabo no porto e uma peste…"}, # 2
	{"speaker": "HILDEGARD", "text": "Não! Não pronuncie tais palavras! Estamos amaldiçoados…"}, # 3
	{"speaker": "VIAJANTE", "text": "Como assim?"}, # 4
	{"speaker": "HILDEGARD", "text": "Há poucas luas, um duque de terras distantes aportou aqui.\nJunto dele, desceram milhares de ratos — e com eles, a morte.\nOs corpos se acumulam nas ruas, e já não há onde andar sem pisar em um doente."}, # 5
	{"speaker": "VIAJANTE", "text": "(baixo) A peste negra…"}, # 6
	{"speaker": "HILDEGARD", "text": "O quê dissestes?"}, # 7
	{"speaker": "VIAJANTE", "text": "Nada… só… em que ano estamos mesmo?"}, # 8
	{"speaker": "HILDEGARD", "text": "Ora, senhor, no ano de Nosso Senhor de 1347."}, # 9
	{"speaker": "VIAJANTE", "text": "(pensando) “Eu tô ferrado… preciso achar um jeito de voltar pra casa.”"}, # 10
	{"speaker": "HILDEGARD", "text": "Nada mais tem valor… perdemos amigos, entes, até nossas casas.\nEm breve partirei com minha família para Avignon, deixarão os servos para trás, para que cuidem das ruínas."}, # 11
	{"speaker": "VIAJANTE", "text": "Eu… sinto muito. Talvez eu possa ajudar."}, # 12
	{"speaker": "HILDEGARD", "text": "Ajudar, senhor? Como?"}, # 13
	{"speaker": "VIAJANTE", "text": "Começando por limpar as ruas — afastar os doentes e tentar impedir que o mal se espalhe.\nExiste algum lugar onde possam ficar em quarentena?"}, # 14
	{"speaker": "HILDEGARD", "text": "Talvez… o estábulo de minha família. Já não o usamos mais."}, # 15
	{"speaker": "VIAJANTE", "text": "Perfeito. Prepare o local, eu trarei os enfermos."}, # 16
	{"speaker": "NARRADOR", "text": "(O jogador faz a task de resgatar e levar os doentes até Hildegard.)"}, # 17 (Task)
	{"speaker": "VIAJANTE", "text": "Hildegard, por favor, mantenha distância.\nConhece alguém que faça remédios?"}, # 18
	{"speaker": "HILDEGARD", "text": "Talvez o médico da família. Encontra-se no centro da cidade.\nÉ um homem sábio, conhecedor das ervas e dos humores do corpo."} # 19
]

var current_dialog_index = 0

# --- ESTA É A FUNÇÃO MAIS IMPORTANTE ---
func _ready():
	avancar_button.pressed.connect(func():
		if is_transitioning:
			return 
		show_next_dialog_line()
	)
	
	set_process_unhandled_input(true)

	# --- CORREÇÃO ESTÁ AQUI ---
	# Esta lógica verifica se viemos do NivelClickPoint
	if GameManager.resume_dialogue_index > 0:
		# Se sim, pula para a linha de diálogo correta (18)
		current_dialog_index = GameManager.resume_dialogue_index
		GameManager.resume_dialogue_index = 0 # Limpa a flag
	# -----------------------------------
	
	start_scene() # Inicia a cena (com o índice de diálogo correto)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if is_transitioning: 
			return
		
		if current_dialog_index < dialog_lines.size(): 
			show_next_dialog_line()
		else:
			print("Diálogo finalizado, aguardando transição...")

func start_scene():
	viajante_sprite.modulate.a = 1.0
	hildegard_sprite.modulate.a = 1.0
	fade_efeito.modulate.a = 0.0
	balao_fala.visible = false
	is_transitioning = false
	show_next_dialog_line()

func show_next_dialog_line():
	if current_dialog_index >= dialog_lines.size():
		hide_dialog_box()
		end_scene()
		return

	# Lógica da Task (Índice 17)
	if current_dialog_index == 17: 
		is_transitioning = true 
		hide_dialog_box()
		
		# Diz ao GameManager para onde voltar (a próxima fala, índice 18)
		GameManager.resume_dialogue_index = 18 
		
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
	
	get_tree().change_scene_to_file("res://NivelClickPoint.tscn")

func hide_dialog_box():
	balao_fala.visible = false
	avancar_button.visible = false

func end_scene():
	is_transitioning = true
	set_process_unhandled_input(false) 
	GameManager.resume_dialogue_index = 0
	
	print("Cena 3 finalizada! Voltando para a vila JOGÁVEL...")
	
	if GameManager:
		GameManager.quest_status = "encontrar_medico" 
	
	get_tree().change_scene_to_file("res://vilarejo.tscn")
