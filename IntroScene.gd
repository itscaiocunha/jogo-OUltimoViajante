extends Node2D

# Referências para os nós da cena
@onready var quarto_fundo = $QuartoFundo
@onready var viajante_sprite = $ViajanteSprite
@onready var bruxo_sprite = $BruxoSprite
@onready var portal_sprite = $PortalSprite
@onready var clarao_fundo = $ClaraoFundo

@onready var ui_script = $UIScript
@onready var balao_fala = $UIScript/BalaoFala
@onready var nome_personagem_label = $UIScript/BalaoFala/NomePersonagemLabel
@onready var texto_dialogo_label = $UIScript/BalaoFala/TextoDialogoLabel
@onready var avancar_button = $UIScript/BalaoFala/AvancarButton

@onready var ambience_player = $AmbiencePlayer
@onready var portal_sfx_player = $PortalSFXPlayer

# --- Diálogos da Cena ---
var dialog_lines = [
	{"speaker": "NARRADOR", "text": "O viajante está sentado em frente ao computador, estudando para a próxima prova com o professor Marcellus. A tela brilha na penumbra do quarto."},
	{"speaker": "NARRADOR", "text": "De repente, uma luz azul começa a pulsar e dançar sobre o monitor. Assustado, o viajante olha para trás — um portal cintilante se abre, e dele sai um homem de vestes antigas e olhar urgente."},
	{"speaker": "BRUXO", "text": "Graças aos céus, consegui chegar até você! Depressa, venha comigo! Não temos tempo a perder!"},
	{"speaker": "VIAJANTE", "text": "Quê? Quem é você? Como entrou aqui?!"},
	{"speaker": "BRUXO", "text": "Ora, achei que fosse óbvio… Rasguei o tecido do tempo e atravessei até tua era.\nAgora, vamos! Ele chegou — o demônio atracou no porto e trouxe consigo a peste!"},
	{"speaker": "VIAJANTE", "text": "O quê? Cara, eu não sei de onde você veio, mas… volta pra lá antes que eu chame a polícia."},
	{"speaker": "NARRADOR", "text": "Tolo mortal… não me deixas escolha, viajante."},
	{"speaker": "NARRADOR", "text": "O bruxo ativa um dispositivo em suas mãos — o chão sob o viajante se abre num clarão. Ele cai, gritando."}
]

var current_dialog_index = 0

func _ready():
	# Conecta o botão de avançar
	avancar_button.pressed.connect(show_next_dialog_line)
	# Adicionamos uma InputEvent para que qualquer clique na tela avance o diálogo
	set_process_unhandled_input(true)

	# --- CORREÇÃO AQUI ---
	# Chamamos a função de início (que mostrará a primeira fala)
	start_intro_sequence()
	# --------------------

func _unhandled_input(event):
	# Se clicar em qualquer lugar da tela E o diálogo não tiver acabado
	if event is InputEventMouseButton and event.pressed:
		if current_dialog_index < dialog_lines.size(): 
			show_next_dialog_line()
		else:
			print("Diálogo finalizado, aguardando transição...")

# --- CORREÇÃO AQUI ---
func start_intro_sequence():
	# Certifique-se de que os Sprites estão invisíveis no início
	bruxo_sprite.modulate.a = 0
	portal_sprite.visible = false
	clarao_fundo.visible = false
	clarao_fundo.modulate.a = 0 # Garante que o clarão esteja transparente
	balao_fala.visible = false

	# Começamos o diálogo imediatamente.
	# Isso mostrará a primeira linha (índice 0)
	show_next_dialog_line()
# --------------------

# --- CORREÇÃO PRINCIPAL AQUI ---
func show_next_dialog_line():
	# Se o diálogo terminou, chama a função de finalização
	if current_dialog_index >= dialog_lines.size():
		hide_dialog_box()
		end_intro_sequence()
		return

	var line_data = dialog_lines[current_dialog_index]
	var speaker = line_data.speaker
	var text = line_data.text

	balao_fala.visible = true

	if speaker == "NARRADOR":
		nome_personagem_label.text = ""
	else:
		nome_personagem_label.text = speaker + ":"
	
	# NÃO mostre o texto do bruxo ainda, se for a hora dos eventos
	if current_dialog_index != 2:
		texto_dialogo_label.text = text

	# --- Lógica de eventos visuais ---
	
	if current_dialog_index == 1:
		portal_sprite.visible = true
		portal_sfx_player.play()
		pass

	elif current_dialog_index == 2:
		
		# 1. Flash de luz rápido
		var flash_tween = create_tween().set_trans(Tween.TRANS_QUINT)
		flash_tween.tween_property(clarao_fundo, "visible", true, 0.0)
		flash_tween.tween_property(clarao_fundo, "modulate:a", 0.7, 0.1) # Flash
		flash_tween.tween_property(clarao_fundo, "modulate:a", 0.0, 0.3) # Some rápido
		flash_tween.tween_property(clarao_fundo, "visible", false, 0.0)

		# 2. Animação principal (Portal e Bruxo)
		var main_tween = create_tween()
		main_tween.set_parallel(false) # Uma coisa depois da outra
		
		# Espera o flash terminar (0.1s + 0.3s)
		main_tween.tween_interval(0.4) 

		# 2. Mostra Portal
		main_tween.tween_property(portal_sprite, "visible", true, 0.0)
		
		# 3. Garante que o bruxo está pronto (visível, na frente)
		main_tween.tween_property(bruxo_sprite, "visible", true, 0.0)
		main_tween.tween_property(bruxo_sprite, "z_index", 1, 0.0)
		main_tween.tween_property(portal_sprite, "z_index", 0, 0.0)

		# 4. Fade-in do Bruxo
		main_tween.tween_property(bruxo_sprite, "modulate:a", 1.0, 1.0)
		main_tween.tween_property(bruxo_sprite, "position:y", bruxo_sprite.position.y - 10, 1.0)
		
		# 5. QUANDO A ANIMAÇÃO ACABAR, mostre a fala do Bruxo
		main_tween.tween_callback(func(): texto_dialogo_label.text = text)

	elif current_dialog_index == 7: 
		# Fade-out final
		var tween = create_tween()
		tween.tween_property(ambience_player, "volume_db", -80, 0.5)
		tween.tween_property(portal_sfx_player, "volume_db", -80, 0.5)
		tween.tween_property(bruxo_sprite, "modulate:a", 0.0, 0.5)
		tween.tween_property(portal_sprite, "visible", false, 0.0)
		tween.tween_property(clarao_fundo, "visible", true, 0.0)
		tween.tween_property(clarao_fundo, "modulate:a", 1.0, 0.1)
		tween.tween_interval(0.5)
		tween.tween_property(clarao_fundo, "modulate:a", 0.0, 0.5)
		tween.tween_callback(end_intro_sequence)
		
		hide_dialog_box()

	current_dialog_index += 1

func hide_dialog_box():
	balao_fala.visible = false
	avancar_button.visible = false

func end_intro_sequence():
	set_process_unhandled_input(false) 
	
	print("Introdução finalizada! Carregando a Cena 2...")
	get_tree().change_scene_to_file("res://Cena02_Medieval.tscn")
