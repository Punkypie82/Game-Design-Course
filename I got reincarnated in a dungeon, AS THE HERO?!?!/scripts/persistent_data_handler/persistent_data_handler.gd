class_name PresistentDataHandler extends Node

signal data_loaded()
var value: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_value()
	pass
	
func set_value( value: int, is_bool: bool ) -> void:
	SaveManager.add_persistent_value( _get_name(), value, is_bool )
	pass
	
func get_value() -> void:
	value = SaveManager.check_persistent_value( _get_name() )
	data_loaded.emit()
	pass
	
func _get_name() -> String:
	return get_tree().current_scene.scene_file_path + '/' + get_parent().name + '/' + name
