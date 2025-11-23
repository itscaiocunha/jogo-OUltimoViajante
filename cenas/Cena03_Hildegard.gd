extends Node2D

# ---------------------------------------------------------
# REFERÊNCIAS DOS NÓS
# ---------------------------------------------------------
@onready var viajante_sprite = $ViajanteSprite
@onready var hildegard_sprite = $HildegardSprite
@onready var fade_efeito = $FadeEfeito

# UI
@onready var balao_fala = $UIScript/BalaoFala
@onready var nome_personagem_label = $UIScript/BalaoFala/NomePersonagemLabel
@onready var texto_dialogo_label = $UIScript/BalaoFala/TextoDialogoLabel
@onready var avancar_button = $UIScript/BalaoFala/AvancarButton

var is_transitioning = false
var is_typing = false   # <-- controle do efeito escrever
var typewriter_speed := 0.02

# ---------------------------------------------------------
# DIÁLOGOS DA CENA 3
# ---------------------------------------------------------
var dialog_lines = [
	{"speaker": "VIAJANTE", "text": "Com licença… você é a Hildegard?"},
	{"speaker": "HILDEGARD", "text": "Sou eu mesma. Que desejas, forasteiro?"},
	{"speaker": "VIAJANTE", "text": "Então… um homem meio esquisito, com um relógio de bolso, pediu pra eu te procurar. Disse algo sobre um… diabo no porto e uma peste…"},
	{"speaker": "HILDEGARD", "text": "Não! Não pronuncie tais palavras! Estamos amaldiçoados…"},
	{"speaker": "VIAJANTE", "text": "Como assim?"},
	{"speaker": "HILDEGARD", "text": "Há poucas luas, um duque de terras distantes aportou aqui.\nJunto dele, desceram milhares de ratos — e com eles, a morte.\nOs corpos se acumulam nas ruas, e já não há onde andar sem pisar em um doente."},
	{"speaker": "VIAJANTE", "text": "(baixo) A peste negra…"},
	{"speaker": "HILDEGARD", "text": "O quê dissestes?"},
	{"speaker": "VIAJANTE", "text": "Nada… só… em que ano estamos mesmo?"},
	{"speaker": "HILDEGARD", "text": "Ora, senhor, no ano de Nosso Senhor de 1347."},
	{"speaker": "VIAJANTE", "text": "(pensando) “Eu tô ferrado… preciso achar um jeito de voltar pra casa.”"},
	{"speaker": "HILDEGARD", "text": "Nada mais tem valor… perdemos amigos, entes, até nossas casas.\nEm breve partirei com minha família para Avignon, deixarão os servos para trás, para que cuidem das ruínas."},
	{"speaker": "VIAJANTE", "text": "Eu… sinto muito. Talvez eu possa ajudar."},
	{"speaker": "HILDEGARD", "text": "Ajudar, senhor? Como?"},
	{"speaker": "VIAJANTE", "text": "Começando por limpar as ruas — afastar os doentes e tentar impedir que o mal se espalhe.\nExiste algum lugar onde possam ficar em quarentena?"},
	{"speaker": "HILDEGARD", "text": "Talvez… o estábulo de minha família. Já não o usamos mais."},
	{"speaker": "VIAJANTE", "text": "Perfeito. Prepare o local, eu trarei os enfermos."},
	{"speaker": "NARRADOR", "text": "(O jogador faz a task de resgatar e levar os doentes até Hildegard.)"},
	{"speaker": "VIAJANTE", "text": "Hildegard, por favor, mantenha distância.\nConhece alguém que faça remédios?"},
	{"speaker": "HILDEGARD", "text": "Talvez o médico da família. Encontra-se no centro da cidade.\nÉ um homem sábio, conhecedor das ervas e dos humores do corpo."}
]

var current_dialog_index := 0

# ---------------------------------------------------------
# READY
# ---------------------------------------------------------
func _ready():
	avancar_button.pressed.connect(_on_next_pressed)
	set_process_unhandled_input(true)

	if GameManager.resume_dialogue_index > 0:
		current_dialog_index = GameManager.resume_dialogue_index
		GameManager.resume_dialogue_index = 0

	start_scene()


# ---------------------------------------------------------
# INPUT
# ---------------------------------------------------------
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		_on_next_pressed()


# ---------------------------------------------------------
# CLICK PARA AVANÇAR
# ---------------------------------------------------------
func _on_next_pressed():
	if is_transitioning:
		return

	# se ainda está escrevendo, pular pro final
	if is_typing:
		is_typing = false
		return

	show_next_dialog_line()


# ---------------------------------------------------------
# INICIAR CENA
# ---------------------------------------------------------
func start_scene():
	viajante_sprite.modulate.a = 1.0
	hildegard_sprite.modulate.a = 1.0
	fade_efeito.modulate.a = 0.0
	balao_fala.visible = false
	show_next_dialog_line()


# ---------------------------------------------------------
# MOSTRAR DIÁLOGO
# ---------------------------------------------------------
func show_next_dialog_line():
	# terminou o diálogo
	if current_dialog_index >= dialog_lines.size():
		hide_dialog_box()
		end_scene()
		return

	# TASK (índice 17)
	if current_dialog_index == 17:
		is_transitioning = true
		hide_dialog_box()

		GameManager.resume_dialogue_index = 18
		fade_and_change_scene()
		return

	var data = dialog_lines[current_dialog_index]
	var speaker = data.speaker
	var text = data.text

	balao_fala.visible = true

	nome_personagem_label.text = "" if speaker == "NARRADOR" else speaker + ":"
	
	# iniciar efeito de escrever
	start_typewriter(text)

	current_dialog_index += 1


# ---------------------------------------------------------
# TYPEWRITER EFFECT (GODOT 4 OFICIAL)
# ---------------------------------------------------------
func start_typewriter(full_text: String) -> void:
	is_typing = true
	texto_dialogo_label.text = ""

	# usar coroutine sem GDScriptFunctionState
	call_deferred("_run_typewriter", full_text)


func _run_typewriter(full_text: String) -> void:
	var visible_text = ""
	for c in full_text:
		if not is_typing:
			# pular para o texto final
			texto_dialogo_label.text = full_text
			return

		visible_text += str(c)
		texto_dialogo_label.text = visible_text
		await get_tree().create_timer(typewriter_speed).timeout

	is_typing = false


# ---------------------------------------------------------
# TRANSIÇÃO DE CENA
# ---------------------------------------------------------
func fade_and_change_scene():
	var tween = create_tween()
	tween.tween_property(fade_efeito, "modulate:a", 1.0, 0.3)
	await tween.finished

	LevelLoader.carregar_cena("res://levels/NivelClickPoint.tscn")


# ---------------------------------------------------------
# UI
# ---------------------------------------------------------
func hide_dialog_box():
	balao_fala.visible = false
	avancar_button.visible = false


# ---------------------------------------------------------
# FINAL DA CENA
# ---------------------------------------------------------
func end_scene():
	is_transitioning = true
	set_process_unhandled_input(false)
	GameManager.resume_dialogue_index = 0
	GameManager.quest_status = "encontrar_medico"

	LevelLoader.carregar_cena("res://levels/vilarejo.tscn")
