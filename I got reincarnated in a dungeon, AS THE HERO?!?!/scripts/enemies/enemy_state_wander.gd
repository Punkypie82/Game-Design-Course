class_name EnemyStateWander extends EnemyState

@export var anim_name: String = 'wander'
@export var wander_speed: float = 100.0

@export_category('AI')
@export var state_animation_duration: float = 0.9
@export var state_cycles_min: int = 1
@export var state_cycles_max: int = 3
@export var next_state: EnemyState

var _timer: float = 0.0
var _direction: Vector2

func Init() -> void:
	pass
	
func Enter() -> void:
	enemy.velocity = Vector2.ZERO
	_timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
	var rand = randi_range(0, 3)
	_direction = enemy.DIR_4[rand]
	enemy.velocity = _direction * wander_speed
	enemy.SetDirection( _direction )
	enemy.UpdateAnimation( anim_name )
	pass
	
func Exit() -> void:
	pass
	
func Process( _delta: float ) -> EnemyState:
	_timer -= _delta
	if enemy._player_detected:
		return enemy.aggro
	if _timer <= 0:
		if enemy._player_detected:
			return enemy.aggro
		return next_state
	return null
	
func Physics( _delta: float ) -> EnemyState:
	enemy.move_and_slide()
	return null
	
