extends CharacterBody2D

# Velocidade do personagem em pixels/segundo
@export var speed = 200.0

# O caminho que a IA calculou
var path: PackedVector2Array = []
var current_waypoint: Vector2 = Vector2.ZERO

func _ready():
	# Lógica de retorno (para quando volta de uma cena de diálogo)
	if GameManager.player_return_position != Vector2.ZERO:
		global_position = GameManager.player_return_position
		GameManager.player_return_position = Vector2.ZERO

func _physics_process(delta):
	# Se o caminho estiver vazio (personagem parado)
	if path.is_empty():
		velocity = Vector2.ZERO
	# Se o caminho NÃO estiver vazio (personagem andando)
	else:
		current_waypoint = path[0]

		if global_position.distance_to(current_waypoint) < 5.0:
			path = path.slice(1) # Remove o ponto do caminho
			if path.is_empty():
				velocity = Vector2.ZERO
		else:
			var direction = global_position.direction_to(current_waypoint)
			velocity = direction * speed
	
	move_and_slide()

# Esta função detecta o clique do mouse
func _unhandled_input(event):
	# O jogador SEMPRE pode clicar para andar
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		
		var mouse_pos = get_global_mouse_position()
		var map = get_world_2d().navigation_map
		var new_path = NavigationServer2D.map_get_path(map, global_position, mouse_pos, true)
		
		if new_path.is_empty():
			return
		if new_path[-1].distance_to(mouse_pos) > 15.0:
			return
		
		self.path = new_path
