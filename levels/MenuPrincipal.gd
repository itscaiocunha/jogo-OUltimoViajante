extends Control

@onready var sfx_player = $SFXPlayer

func _on_play_button_pressed(): # Verifique se o nome da função bate com o sinal conectado!
	sfx_player.play()
	LevelLoader.carregar_cena("res://cenas/IntroScene.tscn") 

func _on_exit_button_pressed():
	sfx_player.play()
	await sfx_player.finished
	get_tree().quit()
