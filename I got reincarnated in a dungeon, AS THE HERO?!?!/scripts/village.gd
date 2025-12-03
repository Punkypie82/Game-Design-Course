class_name Village extends Level


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.y_sort_enabled = true
	PlayerManager.set_as_parent( self )
	LevelManager.level_load_started.connect( _free_level )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_panel_gui_closed() -> void:
	get_tree().paused = false


func _on_panel_gui_opened() -> void:
	get_tree().paused = true

func _free_level() -> void:
	PlayerManager.unparent_player( self )
	queue_free()
