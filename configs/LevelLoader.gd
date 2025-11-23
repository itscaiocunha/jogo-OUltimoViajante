extends Node

# Certifique-se de arrastar o arquivo correto para cá se mudar de lugar!
var loading_screen_path = "res://cenas/TelaCarregamento.tscn"

func carregar_cena(caminho_da_nova_cena: String):
	# Tenta carregar o recurso (a cena)
	var scene_resource = load(loading_screen_path)
	
	# Verificação de segurança: O arquivo existe?
	if scene_resource == null:
		print("ERRO CRÍTICO: Não consegui encontrar a cena de carregamento em: ", loading_screen_path)
		print("Verifique se o nome do arquivo está correto no script LevelLoader.gd")
		# Tenta mudar de cena diretamente sem a tela de carregamento (para o jogo não travar)
		get_tree().change_scene_to_file(caminho_da_nova_cena)
		return

	# Se encontrou, continua normal
	var loading_screen = scene_resource.instantiate()
	
	loading_screen.cena_alvo_path = caminho_da_nova_cena
	
	var root = get_tree().root
	var current_scene = get_tree().current_scene
	
	root.remove_child(current_scene)
	current_scene.queue_free()
	
	root.add_child(loading_screen)
	get_tree().current_scene = loading_screen
