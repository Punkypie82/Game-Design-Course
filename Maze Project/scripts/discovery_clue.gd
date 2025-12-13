extends Area2D

@onready var label: Label = %Player/Label
@onready var game_manager: Node = %GameManager
@onready var panel_gui: Control = %PanelGUI
@onready var discovery_clue: Control = $"../CanvasLayer/PanelGUI/DiscoveryClue"
var playerInDetectionZone = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		label.visible = true
		label.text = 'there is a clue on the wall\n<tap> to view the clue'
		playerInDetectionZone = true
	
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player'):
		label.visible = false
		label.text = '<tab> to open puzzle'
		playerInDetectionZone = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("OpenPanel") and playerInDetectionZone:
		if panel_gui.isOpen:
			panel_gui.close()
			discovery_clue.visible = false
			pass
		else:
			panel_gui.open()
			discovery_clue.visible = true
			pass
