extends Area2D

# --- INÍCIO DAS MUDANÇAS ---
# Definimos os tipos de itens que podem existir
enum ItemType { QUEST_ITEM, LIXO }

# Um novo sinal que envia o nome E o tipo do item
signal item_foi_clicado(item_name, item_type)

# Nova variável! Você vai definir isso no Inspetor
@export var item_type : ItemType = ItemType.QUEST_ITEM 
# --- FIM DAS MUDANÇAS ---

# Variáveis que já tínhamos
@export var item_name: String = "item_desconhecido"
@export var texture: Texture2D

func _ready():
	$Sprite2D.texture = texture
	input_event.connect(_on_input_event)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		
		# --- MUDANÇA AQUI ---
		# Emitimos o NOVO sinal, com os 2 parâmetros
		item_foi_clicado.emit(item_name, item_type)
		# --- FIM DA MUDANÇA ---
		
		$CollisionShape2D.disabled = true
		hide()
