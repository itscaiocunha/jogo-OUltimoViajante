extends Control

# --- Variáveis ---
@onready var creditos_label = $CreditosLabel
@export var scroll_speed: float = 70.0

var tween: Tween
var menu_scene_path = "res://levels/MenuPrincipal.tscn"

func _ready():
	await get_tree().create_timer(0.01).timeout

	var screen_height = get_viewport_rect().size.y
	var text_height = creditos_label.get_content_height()

	var start_y = screen_height

	var final_y = -text_height

	creditos_label.position.y = start_y

	var duration = (screen_height + text_height) / scroll_speed

	tween = create_tween()
	tween.tween_property(creditos_label, "position:y", final_y, duration)

	tween.finished.connect(go_to_menu)

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		go_to_menu()
		
# Função para ir ao menu (evita código duplicado)
func go_to_menu():
	# Impede cliques duplos e para o tween
	set_process_input(false)
	if tween:
		tween.kill()
		tween = null
	
	print("Créditos finalizados. Voltando ao Menu Principal.")
	get_tree().change_scene_to_file(menu_scene_path)
