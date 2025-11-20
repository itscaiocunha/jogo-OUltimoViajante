extends CanvasLayer

# --- 1. Referências para os nós da UI ---
@onready var titulo_label = $PanelContainer/VBoxContainer/TituloLabel
@onready var insignia_imagem = $PanelContainer/VBoxContainer/InsigniaImagem
@onready var descricao_label = $PanelContainer/VBoxContainer/DescricaoLabel
@onready var score_label = $PanelContainer/VBoxContainer/ScoreLabel
@onready var reiniciar_button = $PanelContainer/VBoxContainer/ReiniciarButton

var pode_tentar_novamente = true


func _ready():
	reiniciar_button.pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
	
	if pode_tentar_novamente:
		if not GameManager.game_won:
			GameManager.attempt_count += 1
		else:
			GameManager.attempt_count = 1
			GameManager.game_won = false

		get_tree().reload_current_scene()
		
	else:
		GameManager.attempt_count = 1
		GameManager.game_won = false
		
		self.hide()
		var return_scene = GameManager.minigame_return_scene
		GameManager.minigame_return_scene = "res://levels/vilarejo.tscn" 
		get_tree().change_scene_to_file(return_scene)

func show_results(title: String, description: String, insignia_tex: Texture2D, score: int, total: int):
	
	# Preenche os labels e a imagem com as informações recebidas
	titulo_label.text = title
	descricao_label.text = description
	insignia_imagem.texture = insignia_tex
	score_label.text = "Você acertou %d de %d ingredientes!" % [score, total]
	
	# --- LÓGICA DO BOTÃO ATUALIZADA ---
	
	# Regra 1: Se o jogador ganhou (Alquimista Renomado)
	if GameManager.game_won:
		reiniciar_button.text = "Voltar para vila"
		reiniciar_button.disabled = false
		pode_tentar_novamente = false # Ação: Voltar para vila
	
	# Regra 2: Se o jogador NÃO ganhou
	else:
		# Verifica em qual tentativa estamos
		if GameManager.attempt_count == 1:
			# Esta foi a primeira tentativa (e ele falhou)
			reiniciar_button.text = "Tentar Novamente (1/2)"
			reiniciar_button.disabled = false
			pode_tentar_novamente = true # Ação: Tentar de novo
			
		elif GameManager.attempt_count >= 2:
			# Esta foi a segunda tentativa (e ele falhou)
			# "caso ele falhe as duas vezes..."
			reiniciar_button.text = "Voltar para vila"
			reiniciar_button.disabled = false # Habilita o botão!
			pode_tentar_novamente = false # Ação: Voltar para vila
			
			descricao_label.text = "Ops! Você falhou duas vezes. Suas tentativas acabaram."

	# --- FIM DA NOVA LÓGICA ---

	# Mostra a tela de resultados
	self.show()
