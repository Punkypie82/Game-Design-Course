class_name EnemyStateSlain extends EnemyState

const PICKUP = preload("res://scenes/item_pickup/item_pickup.tscn")

@export var anim_name: String = 'slain'
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0

@export_category('AI')

@export_category('Item Drops')
@export var drops: Array[ DropData ]

var _direction: Vector2
var _damage_position: Vector2


func Init() -> void:
	enemy.enemy_slain.connect( _on_enemy_slain )
	pass

func Enter() -> void:
	enemy.is_slain = true
	enemy.invulnerable = true
	
	_direction = enemy.global_position.direction_to( _damage_position )
	
	enemy.SetDirection( _direction )
	enemy.velocity = _direction * -knockback_speed
	
	enemy.UpdateAnimation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	DisableHurtBox()
	drop_items()
	enemy.is_slain_data.set_value( true, true )
	enemy.update_enemy_count.emit( enemy.enemy_type )
	
func Exit() -> void:
	enemy.queue_free()
	pass
	
func Process( _delta: float ) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
func Physics( _delta: float ) -> EnemyState:
	return null
	
func _on_enemy_slain( hurt_box: HurtBox ) -> void:
	_damage_position = hurt_box.global_position
	enemy_state_machine.ChangeState( self )
	
func _on_animation_finished( _a: String ) -> void:
	enemy.queue_free()

func DisableHurtBox() -> void:
	if enemy.hurt_box:
		enemy.hurt_box.monitoring = false

func drop_items() -> void:
	if drops.size() == 0:
		return
		
	for i in drops.size():
		if drops[i] == null or drops[i].item == null:
			continue
		var drop_count: int = drops[i].get_drop_count()
		for j in drop_count:
			var drop: ItemPickup = PICKUP.instantiate() as ItemPickup
			drop.item_data = drops[i].item
			enemy.get_parent().call_deferred( 'add_child', drop )
			drop.global_position = (enemy.global_position / 2)
			drop.velocity = enemy.velocity.rotated( randf_range( -1.5, 1.5 ) ) * randf_range( 3, 5 )
