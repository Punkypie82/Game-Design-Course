extends Node

const SAVE_PATH = 'user://'

signal game_loaded
signal game_saved

var current_save: Dictionary = {
	scene_path = '',
	player = {
		cash = 1,
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0
	},
	inventory = [],
	persistence = {}
}

func _ready() -> void:
	save_game()

func save_game() -> void:
	update_player_data()
	update_scene_path()
	update_inventory_data()
	var file := FileAccess.open( SAVE_PATH + 'save.sav', FileAccess.WRITE )
	var save_json = JSON.stringify( current_save )
	file.store_line( save_json )
	game_saved.emit()
	pass
	
func load_game( _play_audio: bool = true ) -> void:
	var file := FileAccess.open( SAVE_PATH + 'save.sav', FileAccess.READ )
	var json := JSON.new()
	json.parse( file.get_line() )
	var save_dict: Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	
	LevelManager.load_new_level( current_save.scene_path, "", Vector2.ZERO, _play_audio)
	
	await LevelManager.level_load_started
	
	PlayerManager.set_player_position( Vector2(current_save.player.pos_x, current_save.player.pos_y) )
	PlayerManager.set_health( current_save.player.hp, current_save.player.max_hp )
	PlayerManager.set_cash( current_save.player.cash )
	PlayerManager.INVENTORY_DATA.parse_save_data( current_save.inventory )
	
	await LevelManager.level_loaded
	
	game_loaded.emit()
	pass

func update_player_data() -> void:
	var p: Player = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x / 2
	current_save.player.pos_y = p.global_position.y / 2
	current_save.player.cash = p.cash
	
func update_scene_path() -> void:
	var p: String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p

func update_inventory_data() -> void:
	current_save.inventory = PlayerManager.INVENTORY_DATA.get_save_data()

func add_persistent_value( path: String, value: int , is_bool: bool ) -> void:
	if not check_persistent_value( path ) and is_bool:
		current_save.persistence.merge({str(path): value}, false)
	elif not is_bool:
		current_save.persistence.merge({str(path): value}, true)
	pass

func check_persistent_value( path: String ) -> int:
	var p = current_save.persistence as Dictionary
	if p.has( str(path) ):
		return int(p[str(path)])
	return 0
