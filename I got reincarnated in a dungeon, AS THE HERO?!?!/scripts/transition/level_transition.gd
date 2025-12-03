@tool
class_name LevelTransition extends Area2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_file( '*.tscn' ) var level
@export var target_transition_area: String = "LevelTransition"
@export var locked: bool = false

@export_category('Collision Area Settings')
@export_range( 1, 12, 1, 'or_greater') var size: int = 2:
	set( _v ):
		size = _v
		_update_area()
@export var side: SIDE = SIDE.LEFT:
	set( _v ):
		side = _v
		_update_area()
@export var snap_to_grid: bool = false:
	set( _v ):
		_snap_to_grid()
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var audio_locked: AudioStreamPlayer = $AudioLocked


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	monitoring = false
	_place_player()
	
	await LevelManager.level_loaded
	await get_tree().create_timer(0.5).timeout
	
	monitoring = true
	
	var pcg: PCG = get_parent().get_node_or_null("PCG")
	if pcg:
		print(pcg)
		pcg.level_clear.connect( unlock )

func _update_area() -> void:
	var new_rect: Vector2 = Vector2( 32, 32 )
	var new_position: Vector2 = Vector2.ZERO
	
	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= 16
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += 16
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= 16
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += 16
		
	if collision_shape == null:
		collision_shape = get_node('CollisionShape2D')
		
	collision_shape.shape.size = new_rect
	collision_shape.position = new_position
	pass

func _snap_to_grid() -> void:
	position.x = round( position.x / 16 ) * 16
	position.y = round( position.y / 16 ) * 16


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		if not locked:
			LevelManager.load_new_level( level, target_transition_area, get_offset() )
		else:
			audio_locked.play()
	pass

func _place_player() -> void:
	if name != LevelManager.target_transition:
		return
	PlayerManager.set_player_position( global_position / 2 + LevelManager.position_offset / 2 )
	
func get_offset() -> Vector2:
	var offset: Vector2 = Vector2.ZERO
	var player_pos: Vector2 = PlayerManager.player.global_position
	
	if side == SIDE.RIGHT or side == SIDE.LEFT:
		offset.y = player_pos.y - global_position.y
		offset.x = 16
		if side == SIDE.LEFT:
			offset.x *= -1
	else:
		offset.x = player_pos.x - global_position.x
		offset.y = 100
		if side == SIDE.TOP:
			offset.y = -100
	
	return offset

func unlock() -> void:
	if locked:
		locked = false
