extends Control

@onready var sfx_player = $SFXPlayer

func _on_jogar_button_pressed():
	sfx_player.play()
	
	get_tree().change_scene_to_file("res://cenas/IntroScene.tscn")

func _on_sair_button_pressed():
	sfx_player.play()
	await sfx_player.finished
	get_tree().quit()
