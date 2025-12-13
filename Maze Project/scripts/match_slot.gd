extends StaticBody2D

@export var isOccupied: bool = false
@export var slot_id: int  # Unique identifier for each slot
@export var orientation: int  # 0 for horizontal, 1 for vertical
@onready var game_manager: Node = %GameManager

enum MatchOrientation {HORIZONTAL, VERTICAL}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color(Color.BLACK, 0.7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.isDragging:
		visible = true
	else:
		visible = false
 
func set_is_occupied(value: bool) -> void:
	if isOccupied != value:  # Only update if the state changes
		isOccupied = value
		game_manager.update_slot_occupancy(slot_id, isOccupied)
