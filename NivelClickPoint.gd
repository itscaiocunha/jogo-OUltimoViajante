extends Node2D

# Carregamos o script do ItemClicavel para acessar o enum
const ItemClicavel = preload("res://ItemClicavel.gd")

# Caminho do container do papiro
@onready var container_da_lista = $CanvasLayer/PapiroFundo/VBoxContainer

# Variáveis de progresso (valores padrão; serão substituídos pelo TXT)
var quest_items_restantes = 5
var lixo_encontrado = 0
var lixo_total = 7

# Dicionário para armazenar dados do DSL
var config_nivel = {}

# =========================================================
# =====================  READY() ==========================
# =========================================================
func _ready():
	# Carrega configurações do arquivo texto
	config_nivel = carregar_configuracao_nivel("res://configs/nivel_hildegard.txt")
	aplicar_configuracoes()

	# Atualiza UI
	update_lixo_counter()

	# Conecta sinal de clique
	get_tree().call_group("itens_clicaveis", "connect", "item_foi_clicado", _on_item_clicado)



# =========================================================
# ========================  DSL  ===========================
# =========================================================

func carregar_configuracao_nivel(caminho):
	var dados = {}

	var file = FileAccess.open(caminho, FileAccess.READ)
	if not file:
		push_error("ERRO: Não foi possível abrir " + caminho)
		return dados

	while not file.eof_reached():
		var linha = file.get_line().strip_edges()

		if linha == "" or linha.begins_with("#"):
			continue

		var partes = linha.split("=")
		if partes.size() != 2:
			continue

		var chave = partes[0].strip_edges()
		var valor_str = partes[1].strip_edges()

		var valor
		if valor_str.is_valid_int():
			valor = int(valor_str)
		elif valor_str.is_valid_float():
			valor = float(valor_str)
		else:
			valor = valor_str.strip_escapes()

		dados[chave] = valor

	return dados


func aplicar_configuracoes():
	if config_nivel.has("qtde_lixos"):
		lixo_total = config_nivel["qtde_lixos"]

	if config_nivel.has("qtde_doentes"):
		quest_items_restantes = config_nivel["qtde_doentes"]



# =========================================================
# ================= LÓGICA DE CLIQUE ======================
# =========================================================

func _on_item_clicado(item_name_clicado, item_type):

	print("CLIQUE DETECTADO: ", item_name_clicado, " | Tipo=", item_type)

	if item_type == ItemClicavel.ItemType.QUEST_ITEM:
		print("Processando DOENTE…")

		var item_name_clean = item_name_clicado.strip_edges()

		for node in container_da_lista.get_children():
			if not node is Label:
				continue

			var label_text = node.text.strip_edges()

			if label_text == item_name_clean and not label_text.begins_with("✓"):
				print("Doente encontrado na lista!")
				node.modulate = Color(0.5, 0.5, 0.5)
				node.text = "✓ " + item_name_clean
				quest_items_restantes -= 1
				break

	elif item_type == ItemClicavel.ItemType.LIXO:
		print("Processando LIXO…")
		lixo_encontrado += 1
		update_lixo_counter()

	check_win_condition()



# =========================================================
# ========================  UI  ===========================
# =========================================================

func update_lixo_counter():
	var lixo_label = container_da_lista.get_node("LixoCounterLabel")

	if lixo_label:
		lixo_label.text = "Lixos: %d / %d" % [lixo_encontrado, lixo_total]
	else:
		print("ERRO: Não achei LixoCounterLabel dentro de ", container_da_lista.get_path())



# =========================================================
# =====================  VITÓRIA  =========================
# =========================================================

func check_win_condition():
	if quest_items_restantes == 0 and lixo_encontrado >= lixo_total:

		print("PARABÉNS! Você salvou os enfermos e limpou a área!")

		set_process_unhandled_input(false)

		get_tree().change_scene_to_file("res://Cena03_Hildegard.tscn")
