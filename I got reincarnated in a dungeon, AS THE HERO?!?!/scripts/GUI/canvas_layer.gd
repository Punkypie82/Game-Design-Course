extends CanvasLayer

@onready var panel_gui: Control = $PanelGUI
@onready var shop: StaticBody2D = $"../Shop"
@onready var shop2: StaticBody2D = $"../Shop2"

func _ready() -> void:
	panel_gui.close()
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('toggle_panel') and (shop.inDetecitonZone or shop2.inDetecitonZone):
		if panel_gui.isOpen:
			panel_gui.close()
		else:
			panel_gui.open()
