extends Node2D

# Carregamos o script do ItemClicavel para poder acessar seu 'enum ItemType'
const ItemClicavel = preload("res://levels/ItemClicavel.gd")

@onready var ratos_counter_label = $CanvasLayer/PapiroFundo/VBoxContainer/RatosCounterLabel

var ratos_encontrados = 0
var ratos_total = 10

func _ready():
	update_ratos_counter()
	
	get_tree().call_group("itens_clicaveis", "connect", "item_foi_clicado", _on_item_clicado)

func _on_item_clicado(item_name_clicado, item_type):
	
	if item_type == ItemClicavel.ItemType.LIXO:
		print("...Processando como RATO (LIXO).")
		ratos_encontrados += 1
		update_ratos_counter()
		
		check_win_condition()
	
	elif item_type == ItemClicavel.ItemType.QUEST_ITEM:
		print("Item de quest ignorado nesta cena.")


func update_ratos_counter():
	if ratos_counter_label:
		ratos_counter_label.text = "Ratos: %d / %d" % [ratos_encontrados, ratos_total]
	else:
		print("ERRO: Não achei o nó 'RatosCounterLabel'!")

func check_win_condition():
	if ratos_encontrados >= ratos_total:
		
		print("PARABÉNS! Você eliminou os ratos!")

		set_process_unhandled_input(false)

		if GameManager:
			GameManager.quest_status = "ratos_eliminados"
		
		LevelLoader.carregar_cena("res://cenas/Cena07_Despedida.tscn")
