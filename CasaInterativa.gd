extends Area2D

@export var target_scene: PackedScene

func _ready():
	self.input_event.connect(_on_input_event)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if target_scene:
			var player_node = get_tree().get_first_node_in_group("player")
			if player_node:
				GameManager.player_return_position = player_node.global_position
				print("Posição do jogador salva: ", GameManager.player_return_position)
			else:
				print("AVISO: CasaInterativa não encontrou nó do 'player'!")
			get_tree().change_scene_to_packed(target_scene)
		else:
			print("ERRO: Nenhuma 'Target Scene' foi definida para esta CasaInterativa!")
