class_name EnemySlimeStateAggro extends EnemyState

@export var anim_name: String = 'aggro'
@export var aggro_speed: float = 120.0

@export_category('AI')
@export var state_animation_duration: float = 0.9
@export var next_state: EnemyState

var _timer: float = 0.0
var _current_cycles: int = 0
var _player_position: Vector2
var _relative_direction: Vector2
var _direction: Vector2

func Init() -> void:
	enemy.detection_zone.body_entered.connect( _on_detection_zone_entered )
	enemy.detection_zone.body_exited.connect( _on_detection_zone_exited )
	pass
	
func Enter() -> void:
	_timer = state_animation_duration
	
	_player_position = enemy.player.global_position
	_relative_direction = enemy.global_position.direction_to( _player_position )
	_direction = ManhattanDirection(_relative_direction)
	
	enemy.velocity = _direction * aggro_speed
	
	enemy.SetDirection( _direction )
	enemy.UpdateAnimation( anim_name )
	
func Exit() -> void:
	pass
	
func Process( _delta: float ) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		if not enemy._player_detected:
			return next_state
		
		_timer = state_animation_duration
		
		_player_position = enemy.player.global_position
		_relative_direction = enemy.global_position.direction_to( _player_position )
		_direction = ManhattanDirection(_relative_direction)
		
		enemy.velocity = _direction * aggro_speed
		enemy.SetDirection( _direction )
		enemy.UpdateAnimation( anim_name )
		
		return self
		
	return null
	
func Physics( _delta: float ) -> EnemyState:
	enemy.move_and_slide()
	return null
	
func ManhattanDirection( _relative_direction: Vector2 ) -> Vector2:
	var directions = []
	
	if abs(_relative_direction.x) > abs(_relative_direction.y):
		if _relative_direction.x > 0:
			return Vector2.RIGHT
		elif _relative_direction.x < 0:
			return Vector2.LEFT
	else:		
		if _relative_direction.y > 0:
			return Vector2.DOWN
		elif _relative_direction.y < 0:
			return Vector2.UP

	return Vector2.ZERO
	
func _on_detection_zone_entered( body: Node2D ) -> void:
	if body.is_in_group('Player'):
		enemy_state_machine.ChangeState( self )
		enemy._player_detected = true
	
func _on_detection_zone_exited( body: Node2D ) -> void:
	if body.is_in_group('Player'):
		enemy._player_detected = false
