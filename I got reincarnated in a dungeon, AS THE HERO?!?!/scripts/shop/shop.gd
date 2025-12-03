extends StaticBody2D

var inDetecitonZone = false

func _on_detection_area_body_entered(body: Node2D) -> void:
	PlayerManager.player.get_node('Subtitle').visible = true
	inDetecitonZone = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	PlayerManager.player.get_node('Subtitle').visible = false
	inDetecitonZone = false
