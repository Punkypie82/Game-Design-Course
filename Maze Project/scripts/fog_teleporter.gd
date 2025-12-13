extends Node2D

@onready var game_manager: Node = %GameManager
var enabled = false

func _init() -> void:
	Global.out_of_fog.connect(_on_out_of_fog)
	
func _on_out_of_fog() -> void:
	enabled = false
	
	
func _on_entrance_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player') and not game_manager.has_all_items():
		enabled = true
		
		
func _on_teleport_detector_1_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player') and enabled:
		body.set_position($DestinationPoint.global_position)
		Global.out_of_fog.emit()


func _on_teleport_detector_2_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player') and enabled:
		body.set_position($DestinationPoint.global_position)
		Global.out_of_fog.emit()


func _on_teleport_detector_3_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player') and enabled:
		body.set_position($DestinationPoint.global_position)
		Global.out_of_fog.emit()
