class_name EnemyGoblinStateAggro extends EnemyState

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
	enemy.navigation_agent.velocity_computed.connect( _on_velocity_computed )
	pass
	
func Enter() -> void:
	_timer = state_animation_duration
	enemy.hurt_box.monitoring = true
	enemy.velocity = Vector2.ZERO
	enemy.navigation_agent.set_velocity(Vector2.ZERO)
	enemy.navigation_agent.target_position = enemy.player.global_position
	
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
		
		enemy.SetDirection( _direction )
		enemy.UpdateAnimation( anim_name )
		
	return null
	
func Physics( _delta: float ) -> EnemyState:
	_player_position = enemy.player.global_position
	enemy.navigation_agent.target_position = _player_position

	var current_agent_position = enemy.global_position
	var next_path_position = enemy.navigation_agent.get_next_path_position()
	var new_velocity = current_agent_position.direction_to( next_path_position ) * aggro_speed
	if enemy.navigation_agent.avoidance_enabled:
		enemy.navigation_agent.set_velocity( new_velocity )
	else:
		_on_velocity_computed( new_velocity )
	enemy.move_and_slide()
	return null

func _on_velocity_computed( safe_velocity: Vector2 ) -> void:
	enemy.velocity = safe_velocity
	
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
		enemy.navigation_agent.set_velocity(Vector2.ZERO)
		enemy._player_detected = true
		enemy.navigation_agent.target_position = enemy.player.global_position 
		enemy.navigation_agent.avoidance_enabled = false
	
func _on_detection_zone_exited( body: Node2D ) -> void:
	if body.is_in_group('Player'):
		enemy._player_detected = false
		enemy.navigation_agent.set_velocity(Vector2.ZERO)
		enemy.navigation_agent.avoidance_enabled = false
