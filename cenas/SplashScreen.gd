extends Control

@onready var video_player = $VideoStreamPlayer
var menu_scene = "res://levels/MenuPrincipal.tscn" # Verifique o caminho!

func _ready():
	# Conecta o sinal de quando o vídeo termina
	video_player.finished.connect(_on_video_finished)
	
	# (Opcional) Força o vídeo a tocar se o Autoplay falhar
	if not video_player.is_playing():
		video_player.play()

func _on_video_finished():
	go_to_menu()

func _input(event):
	# Permite pular o vídeo clicando ou apertando qualquer tecla
	if event is InputEventKey and event.pressed:
		go_to_menu()
	elif event is InputEventMouseButton and event.pressed:
		go_to_menu()

func go_to_menu():
	# Troca para o menu principal
	# Não precisamos do LevelLoader aqui, pois é uma transição rápida
	get_tree().change_scene_to_file(menu_scene)
