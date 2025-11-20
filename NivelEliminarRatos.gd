extends Node2D

# Carregamos o script do ItemClicavel para poder acessar seu 'enum ItemType'
const ItemClicavel = preload("res://ItemClicavel.gd")

# --- ATENÇÃO: Verifique este caminho! ---
# Deve apontar para o seu Label de contador de ratos, dentro do papiro.
@onready var ratos_counter_label = $CanvasLayer/PapiroFundo/VBoxContainer/RatosCounterLabel

# --- Defina seus objetivos ---
var ratos_encontrados = 0
var ratos_total = 10 # Mude este número se quiser mais (ou menos) ratos

func _ready():
	# Define o texto inicial do contador
	update_ratos_counter()
	
	# Conecta o sinal de todos os itens clicáveis na cena
	get_tree().call_group("itens_clicaveis", "connect", "item_foi_clicado", _on_item_clicado)

func _on_item_clicado(item_name_clicado, item_type):
	
	# SÓ nos importamos com itens do tipo LIXO
	if item_type == ItemClicavel.ItemType.LIXO:
		print("...Processando como RATO (LIXO).")
		ratos_encontrados += 1
		update_ratos_counter()
		
		# Verifica se o jogador ganhou após cada clique
		check_win_condition()
	
	# Ignora completamente os itens do tipo QUEST_ITEM
	elif item_type == ItemClicavel.ItemType.QUEST_ITEM:
		print("Item de quest ignorado nesta cena.")


func update_ratos_counter():
	if ratos_counter_label:
		ratos_counter_label.text = "Ratos: %d / %d" % [ratos_encontrados, ratos_total]
	else:
		print("ERRO: Não achei o nó 'RatosCounterLabel'!")

func check_win_condition():
	# Verifica se o jogador encontrou todos os ratos
	if ratos_encontrados >= ratos_total:
		
		print("PARABÉNS! Você eliminou os ratos!")
		
		# Desativa os cliques para não bugar
		set_process_unhandled_input(false)
		
		# Atualiza o status da quest para o GameManager
		if GameManager:
			GameManager.quest_status = "ratos_eliminados"
		
		# Carrega a cena final de despedida!
		get_tree().change_scene_to_file("res://Cena07_Despedida.tscn")
