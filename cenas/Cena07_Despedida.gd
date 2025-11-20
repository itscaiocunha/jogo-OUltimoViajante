extends Node2D

# --- CORREÇÃO 1: Faltavam estas referências ---
@onready var viajante_sprite = $ViajanteSprite
@onready var hildegard_sprite = $HildegardSprite
@onready var bruxo_sprite = $BruxoSprite
@onready var balao_fala = $UIScript/BalaoFala
@onready var nome_personagem_label = $UIScript/BalaoFala/NomePersonagemLabel
@onready var texto_dialogo_label = $UIScript/BalaoFala/TextoDialogoLabel
@onready var avancar_button = $UIScript/BalaoFala/AvancarButton
@onready var clarao_fundo = $ClaraoFundo # Adicione este ColorRect (preto ou azul) à sua cena!
# ----------------------------------------------

var dialog_lines = [
	{"speaker": "VIAJANTE", "text": "Acredito que não precisarás mais partir. A praga está controlada."}, # 0
	{"speaker": "HILDEGARD", "text": "Bendito sejas, senhor! És um enviado dos céus!"}, # 1
	{"speaker": "BRUXO", "text": "Aí está você, viajante! Consertei o aparelho, mas ele está instável.\nSe não formos agora, ficarás preso neste tempo para sempre!"}, # 2
	{"speaker": "VIAJANTE", "text": "Espere — preciso me despedir."}, # 3
	{"speaker": "HILDEGARD", "text": "Vá, jovem senhor. Que os deuses te guardem."}, # 4
	# --- Lógica da Insígnia ---
	{"speaker": "NARRADOR", "text": "(Hildegard lhe entrega uma insígnia por sua bravura.)"}, # 5
	{"speaker": "VIAJANTE", "text": "Adeus… e boa sorte."}, # 6
	{"speaker": "NARRADOR", "text": "(Um clarão azul. O viajante desperta sobre os livros, no quarto.)"} # 7
]

var current_dialog_index = 0

func _ready():
	# Verifica se o jogador merece a insígnia
	# (Se 'attempt_count' ainda for 1, ele ganhou de primeira)
	if GameManager.attempt_count > 1:
		# Se ele falhou, removemos a fala da insígnia (índice 5)
		dialog_lines.remove_at(5)
		print("Insígnia removida, o jogador falhou.")
	
	# Agora sim, conecta o botão (ele já existe)
	avancar_button.pressed.connect(show_next_dialog_line)
	set_process_unhandled_input(true)
	
	start_scene()

# --- CORREÇÃO: Adicionando _unhandled_input ---
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if current_dialog_index < dialog_lines.size(): 
			show_next_dialog_line()
		else:
			print("Diálogo finalizado, aguardando transição...")
# -----------------------------------------------

func start_scene():
	viajante_sprite.modulate.a = 1.0
	hildegard_sprite.modulate.a = 1.0
	bruxo_sprite.modulate.a = 0.0	
	balao_fala.visible = false
	show_next_dialog_line()

func show_next_dialog_line():
	# Se o diálogo terminou, chama a função de finalização
	if current_dialog_index >= dialog_lines.size():
		# Não chama end_scene() aqui, a fala 7 vai chamar
		return

	# --- CORREÇÃO 3: Lógica do clarão e 'tween' ---
	# Esta é a última fala, o "Clarão Azul"
	if current_dialog_index == dialog_lines.size() - 1:
		hide_dialog_box()
		
		# Pega o texto da última fala
		var line_data = dialog_lines[current_dialog_index]
		balao_fala.visible = true
		nome_personagem_label.text = ""
		texto_dialogo_label.text = line_data.text
		
		# Cria um TWEEN para o clarão
		var tween = create_tween()
		tween.tween_interval(1.5) # Tempo para ler a última fala
		tween.tween_property(clarao_fundo, "visible", true, 0.0)
		tween.tween_property(clarao_fundo, "modulate:a", 1.0, 0.2) # Clarão
		# QUANDO O TWEEN ACABAR, chama end_scene
		tween.tween_callback(end_scene)
		
		current_dialog_index += 1
		return
	# --- FIM DA CORREÇÃO 3 ---

	var line_data = dialog_lines[current_dialog_index]
	var speaker = line_data.speaker
	var text = line_data.text
	balao_fala.visible = true
	
	if speaker == "NARRADOR":
		nome_personagem_label.text = ""
	else:
		nome_personagem_label.text = speaker + ":"
	
	texto_dialogo_label.text = text

	# --- Eventos Visuais ---
	if speaker == "BRUXO" and bruxo_sprite.modulate.a == 0.0: # Fala 2
		var tween = create_tween()
		tween.tween_property(bruxo_sprite, "modulate:a", 1.0, 0.5) # Bruxo aparece
	
	current_dialog_index += 1

# --- CORREÇÃO 2: Faltava esta função ---
func hide_dialog_box():
	balao_fala.visible = false
	avancar_button.visible = false
# --------------------------------------

func end_scene():
	set_process_unhandled_input(false) 
	# Carrega a cena final
	get_tree().change_scene_to_file("res://cenas/Cena08_QuartoFinal.tscn")
