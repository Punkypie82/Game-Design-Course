extends CanvasLayer

@onready var button_save: Button = $PanelGUI/VBoxContainer/ButtonSave
@onready var button_load: Button = $PanelGUI/VBoxContainer/ButtonLoad

var is_paused: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_pause_menu()
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('pause'):
		if is_paused:
			hide_pause_menu()
		else:
			show_pause_menu()	
		get_viewport().set_input_as_handled()
		
func show_pause_menu() -> void:
	Inventory.hide_inventory()
	get_tree().paused = true
	visible = true
	is_paused = true
	button_save.grab_focus()
	
func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false


func _on_button_save_pressed() -> void:
	if not is_paused:
		return
	SaveManager.save_game()
	hide_pause_menu()
	pass # Replace with function body.


func _on_button_load_pressed() -> void:
	if not is_paused:
		return
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()
	pass # Replace with function body.
