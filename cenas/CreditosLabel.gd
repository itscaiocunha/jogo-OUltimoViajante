extends Control

# --- Variáveis ---
# ATENÇÃO: O caminho mudou porque agora ele é filho da MascaraCreditos
@onready var creditos_label = $MascaraCreditos/CreditosLabel 
@export var scroll_speed: float = 70.0

var tween: Tween
var menu_scene_path = "res://levels/MenuPrincipal.tscn" # Verifique se o caminho está certo!

func _ready():
	await get_tree().create_timer(0.01).timeout

	# A altura da área visível agora é a altura da MÁSCARA, não da tela inteira
	var view_height = $MascaraCreditos.size.y 
	var text_height = creditos_label.get_content_height()

	# Posição inicial: logo abaixo da máscara
	var start_y = view_height
	
	# Posição final: o texto sobe até sumir completamente acima da máscara
	var final_y = -text_height

	creditos_label.position.y = start_y

	# Calcula a duração baseada na distância total a percorrer
	var duration = (view_height + text_height) / scroll_speed

	tween = create_tween()
	tween.tween_property(creditos_label, "position:y", final_y, duration)

	tween.finished.connect(go_to_menu)

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		go_to_menu()
		
func go_to_menu():
	set_process_input(false)
	if tween:
		tween.kill()
		tween = null
	
	print("Créditos finalizados. Voltando ao Menu Principal.")
	get_tree().change_scene_to_file(menu_scene_path)
