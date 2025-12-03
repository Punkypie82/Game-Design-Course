class_name EnemySlimeStateAttack extends EnemyState

@export var anim_name: String = 'attack'

@export_category('AI')
@export var state_animation_duration: float = 1.2
@export var next_state: EnemyState

var _timer: float = 0.0
var _current_cycles: int = 0
var _player_position: Vector2
var _relative_direction: Vector2
var _direction: Vector2

func Init() -> void:
	enemy.attack_zone.body_entered.connect( _on_attack_zone_entered )
	pass
	
func Enter() -> void:
	_timer = state_animation_duration
	
	enemy.SetDirection( _direction )
	enemy.UpdateAnimation( anim_name )
	
func Exit() -> void:
	pass
	
func Process( _delta: float ) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return next_state
	return null
	
func Physics( _delta: float ) -> EnemyState:
	return null
	
func _on_attack_zone_entered( body: Node2D ) -> void:
	if body.is_in_group('Player'):
		enemy_state_machine.ChangeState( self )
