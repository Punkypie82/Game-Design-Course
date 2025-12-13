extends CanvasLayer

@onready var panel: Control = $PanelGUI
@onready var player: CharacterBody2D = %Player

func _ready() -> void:
	panel.close()

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("OpenPanel"):
		#if panel.isOpen:
			#panel.close()
		#else:
			#panel.open()
