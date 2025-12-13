extends Area2D

@onready var game_manager: Node = %GameManager
@onready var fog_sprite: Sprite2D = $Sprite2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		if (game_manager.has_all_items()):
			var tween = create_tween()
			tween.tween_property(fog_sprite, "modulate:a", 0.3, 0.4) 
		else:
			game_manager.decrease_score(10)
			

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player'):
		if (game_manager.has_all_items()):
			var tween = create_tween()
			tween.tween_property(fog_sprite, "modulate:a", 1, 0.4)
