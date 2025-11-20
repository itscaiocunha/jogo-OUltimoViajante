extends Area2D

@export var ingredient_name: String = "default"
@export var texture: Texture2D

var is_dragging = false
var start_position = Vector2.ZERO

func _ready():
	$Sprite2D.texture = texture
	start_position = global_position
	
	input_event.connect(_on_input_event)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = event.is_pressed()

		if is_dragging:
			z_index = 10
		else:
			z_index = 0
			check_drop_location()

func _process(delta):
	if is_dragging:
		global_position = get_global_mouse_position()

func check_drop_location():
	var overlapping_areas = get_overlapping_areas()
	var on_pot = false
	
	for area in overlapping_areas:
		if area.is_in_group("pot_area"):
			area.receive_ingredient(self)
			on_pot = true
			break

	if on_pot:
		queue_free()
	else:
		global_position = start_position
