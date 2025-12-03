extends Node2D

var draggable = false
var isInsideDroppable = false
var bodyRef
var offset: Vector2
var initialPos: Vector2
@onready var game_manager: Node = %GameManager
@export var orientation: int  # 0 for horizontal, 1 for vertical

enum MatchOrientation {HORIZONTAL, VERTICAL}

func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			Global.isDragging = true
			# Reset the previous slot's occupancy if it exists
			if bodyRef and bodyRef.has_method("set_is_occupied"):
				bodyRef.set_is_occupied(false)
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			Global.isDragging = false
			var tween = get_tree().create_tween()
			if isInsideDroppable and bodyRef and not bodyRef.isOccupied and bodyRef.orientation == orientation:
				bodyRef.set_is_occupied(true)
				game_manager.decrease_turns()
				tween.tween_property(self, "position", bodyRef.position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('dropable'):
		isInsideDroppable = true
		body.modulate = Color(Color.BLACK, 1)
		bodyRef = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('dropable'):
		isInsideDroppable = false
		body.modulate = Color(Color.BLACK, 0.7)
		bodyRef = null

func _on_area_2d_mouse_entered() -> void:
	if not Global.isDragging:
		draggable = true
		scale = Vector2(2.1, 2.1)
		
func _on_area_2d_mouse_exited() -> void:
	if not Global.isDragging:
		draggable = false
		scale = Vector2(2, 2)
