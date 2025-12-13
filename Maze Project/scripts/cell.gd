extends Node2D

# Enum for different states of a cell
enum State {Unchanged, Healthy, Crumbled, Broken}
@export var in_fog: bool = false
# Get cell Sprites
@onready var healthy: Sprite2D = $Detection/Healthy
@onready var crumbled: Sprite2D = $Detection/Crumbled
@onready var broken: Sprite2D = $Detection/Broken

# Get destroyed cell Colider
@onready var collision_shape: CollisionShape2D = $Destruction/CollisionShape2D
@onready var game_manager = $"/root/Main/GameManager"
# Set initial state to Healthy
var curr_state = State.Unchanged

	
func _on_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player'):
		if not in_fog or game_manager.has_all_items():
			if curr_state == State.Unchanged:
				curr_state = State.Healthy
				game_manager.decrease_score(10)
			elif curr_state == State.Healthy:
				curr_state = State.Crumbled
				crumbled.visible = true
				healthy.visible = false
				game_manager.decrease_score(10)
			elif curr_state == State.Crumbled:
				curr_state = State.Broken
				broken.visible = true
				crumbled.visible = false
				collision_shape.call_deferred("set", "disabled", false)
				game_manager.decrease_score(30)
