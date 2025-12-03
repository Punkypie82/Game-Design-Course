extends CanvasLayer

signal shown
signal hidden

var is_inventory_open: bool = false
@onready var item_description: Label = $PanelGUI/ItemDescription

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_inventory()
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('inventory'):
		if is_inventory_open:
			hide_inventory()
		else:
			show_inventory()	
		get_viewport().set_input_as_handled()
		
func show_inventory() -> void:
	get_tree().paused = true
	visible = true
	is_inventory_open = true
	shown.emit()
	
	
func hide_inventory() -> void:
	get_tree().paused = false
	visible = false
	is_inventory_open = false
	hidden.emit()

func update_item_description( new_text: String ) -> void:
	item_description.text = new_text
	
