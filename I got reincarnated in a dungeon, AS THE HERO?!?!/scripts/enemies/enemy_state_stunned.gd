class_name EnemyStateStunned extends EnemyState

@export var anim_name: String = 'stunned'
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0

@export_category('AI')
@export var next_state: EnemyState

var _direction: Vector2
var _damage_position: Vector2
var _animation_finished: bool = false

func Init() -> void:
	enemy.enemy_stunned.connect( _on_enemy_stunned )
	pass

func Enter() -> void:
	enemy.invulnerable = true
	_animation_finished = false
	
	_direction = enemy.global_position.direction_to( _damage_position )
	
	enemy.SetDirection( _direction )
	enemy.velocity = _direction * -knockback_speed
	
	enemy.UpdateAnimation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	
func Exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect( _on_animation_finished )
	pass
	
func Process( _delta: float ) -> EnemyState:
	if _animation_finished:
		if enemy._player_detected:
			return enemy.aggro
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
func Physics( _delta: float ) -> EnemyState:
	return null
	
func _on_enemy_stunned( hurt_box: HurtBox ) -> void:
	_damage_position = hurt_box.global_position
	enemy_state_machine.ChangeState( self )
	
func _on_animation_finished( _a: String ) -> void:
	_animation_finished = true
