extends Area2D

# --- 1. Variáveis para as Insígnias ---
@export var insignia_renomado: Texture2D
@export var insignia_curioso: Texture2D
@export var insignia_azarado: Texture2D

# --- 2. Referência aos nós da UI ---
@onready var tela_resultado = get_node("/root/FaseReceita/TelaResultado")
@onready var contador_label = get_node("/root/FaseReceita/ContadorLabel") 

# --- 3. A Receita e o Progresso ---
var correct_recipe = ["alho", "hortela", "mel", "cogumelo_certo", "gengibre", "calendula"]
var player_ingredients = []

# --- NOVA FUNÇÃO ---
func _ready():
	# Reseta o 'game_won' no início de cada fase
	GameManager.game_won = false 
	
	# Inicia o texto do contador
	contador_label.text = "%d / %d" % [0, correct_recipe.size()]

# Esta função é chamada pelo script do Ingrediente quando ele é solto aqui
func receive_ingredient(ingredient):
	var ingredient_name = ingredient.ingredient_name
	
	print("Recebeu o ingrediente: ", ingredient_name)
	
	player_ingredients.append(ingredient_name)
	
	# Atualiza o texto do contador
	contador_label.text = "%d / %d" % [player_ingredients.size(), correct_recipe.size()]
	
	if player_ingredients.size() == correct_recipe.size():
		evaluate_recipe()


# Função para verificar a receita e mostrar a insígnia
func evaluate_recipe():
	var correct_count = 0
	
	# Loop para verificar cada ingrediente
	for ingredient_name in player_ingredients:
		if correct_recipe.has(ingredient_name):
			correct_count += 1
			
	print("Total de acertos (em qualquer ordem): ", correct_count)
	
	# --- 4. Lógica das Insígnias ---
	var title: String
	var description: String
	var insignia_tex: Texture2D

	if correct_count == 6:
		title = "Alquimista Renomado"
		description = "Perfeito! A poção saiu exatamente como o planejado."
		insignia_tex = insignia_renomado
		GameManager.game_won = true
		
	elif correct_count >= 3:
		title = "Alquimista Curioso"
		description = "Quase lá! Você tem talento para isso."
		insignia_tex = insignia_curioso
	else:
		title = "Experimentador Azarado"
		description = "Ops! A poção não saiu como esperado. Tente novamente!"
		insignia_tex = insignia_azarado
		
	# --- 5. Chama a nova tela ---
	tela_resultado.show_results(
		title,
		description,
		insignia_tex,
		correct_count,
		correct_recipe.size()
	)
	
	# Opcional: Desativa o jarro
	self.set_monitoring(false)
