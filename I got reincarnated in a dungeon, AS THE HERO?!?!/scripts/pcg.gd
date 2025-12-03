class_name PCG extends Node

signal level_clear

@export_category('Enemy Spawn')
@export var level_tilemap: LevelTileMap
@export var enemy_type: Array[ String ]
@export var min_spawn_count: Array[ int ]
@export var max_spawn_count: Array[ int ]

@onready var pcg_completed_data: PresistentDataHandler = $pcg_completed_data
@onready var slime_spawn_count: PresistentDataHandler = $slime_spawn_count
@onready var goblin_spawn_count: PresistentDataHandler = $goblin_spawn_count

var pcg_run_complete: bool = false
var enemy: PackedScene
var slime_spawn_count_data: int = 0
var goblin_spawn_count_data: int = 0

func _ready() -> void:
	pcg_completed_data.data_loaded.connect( set_pcg_completed )
	slime_spawn_count.data_loaded.connect( set_slime_spawn_count )
	goblin_spawn_count.data_loaded.connect( set_goblin_spawn_count )
	set_pcg_completed()
	
	var tile_map_bounds = level_tilemap.get_tilemap_bounds()
	
	if not pcg_run_complete:
		pcg_run_complete = true
		pcg_completed_data.set_value( pcg_run_complete, true )
		
		for i in enemy_type.size():
			var spawn_count = randi_range( min_spawn_count[i], max_spawn_count[i] )
			if enemy_type[i] == null:
				continue
			
			if enemy_type[i] == 'slime':
				slime_spawn_count.set_value( spawn_count, false )
				slime_spawn_count_data = spawn_count
			elif enemy_type[i] == 'goblin':
				goblin_spawn_count.set_value( spawn_count, false )
				goblin_spawn_count_data = spawn_count
				
			for j in spawn_count:
				if enemy_type[i] == 'slime':
					enemy = GlobalEnemyManager.SLIME
				elif enemy_type[i] == 'goblin':
					enemy = GlobalEnemyManager.GOBLIN
				var spawn: Enemy = enemy.instantiate() as Enemy
				spawn.update_enemy_count.connect( update_enemy_count )
				spawn.y_sort_enabled = true
				spawn.global_position.x = randf_range( tile_map_bounds[0].x + 250, tile_map_bounds[1].x -250 ) / 2
				spawn.global_position.y = randf_range( tile_map_bounds[0].y + 250, tile_map_bounds[1].y -450 ) / 2
				self.get_parent().call_deferred( 'add_child', spawn )
	else:
		for i in enemy_type.size():
			var spawn_count: int
			if enemy_type[i] == null:
				continue
			
			if enemy_type[i] == 'slime':
				set_slime_spawn_count()
				spawn_count = slime_spawn_count_data
			elif enemy_type[i] == 'goblin':
				set_goblin_spawn_count()
				spawn_count = goblin_spawn_count_data
			
			if slime_spawn_count_data == 0 and slime_spawn_count_data == 0:
				level_clear.emit()
			
			for j in spawn_count:
				if enemy_type[i] == 'slime':
					enemy = GlobalEnemyManager.SLIME
				elif enemy_type[i] == 'goblin':
					enemy = GlobalEnemyManager.GOBLIN
				var spawn: Enemy = enemy.instantiate() as Enemy
				spawn.update_enemy_count.connect( update_enemy_count )
				spawn.y_sort_enabled = true
				spawn.global_position.x = randf_range( tile_map_bounds[0].x + 250, tile_map_bounds[1].x -250 ) / 2
				spawn.global_position.y = randf_range( tile_map_bounds[0].y + 250, tile_map_bounds[1].y -450 ) / 2
				self.get_parent().call_deferred( 'add_child', spawn )

func _process(delta: float) -> void:
	if slime_spawn_count_data == 0 and slime_spawn_count_data == 0:
		level_clear.emit()

func set_pcg_completed() -> void:
	pcg_run_complete = pcg_completed_data.value

func set_slime_spawn_count() -> void:
	slime_spawn_count_data = slime_spawn_count.value
	
func set_goblin_spawn_count() -> void:
	goblin_spawn_count_data = goblin_spawn_count.value

func update_enemy_count( enemy_type: String ) -> void:
	if enemy_type == 'slime':
		slime_spawn_count_data -= 1;
		slime_spawn_count.set_value( slime_spawn_count_data, false )
	elif enemy_type == 'goblin':
		goblin_spawn_count_data -= 1;
		goblin_spawn_count.set_value( goblin_spawn_count_data, false )
		
