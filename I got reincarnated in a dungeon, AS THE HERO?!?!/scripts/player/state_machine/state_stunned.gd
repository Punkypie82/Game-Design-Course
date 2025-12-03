class_name StateStunned extends State

@export var knockback_speed: float = 700.0
@export var decelerate_speed: float = 5.0
@export var invulnerable_duration: float = 0.3

@onready var walk: StateWalk = $"../Walk"
@onready var idle: StateIdle = $"../Idle"

var hurt_box: HurtBox
var direction: Vector2
var _timer: float = 0.0

func Init() -> void:
	player.player_stunned.connect( _on_player_stunned )

func Enter() -> void:
	direction = player.global_position.direction_to( hurt_box.global_position )
	player.velocity = direction * -knockback_speed
	player.SetDirection()
	
	player.MakeInvulnerable( invulnerable_duration )
	
	_timer = invulnerable_duration

	flash_red()
	pass
	
func Exit() -> void:
	pass
	
func Process( _delta: float ) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	_timer -= _delta
	if _timer <= 0:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
func Physics( _delta: float ) -> State:
	return null
	
func HandleInput( _event: InputEvent ) -> State:
	return null

func flash_red():
	var tween = create_tween()
	# Modulate to red over 0.5 seconds
	tween.tween_property(player.player_sprite, "modulate", Color(1, 0, 0), invulnerable_duration/2)
	# Modulate back to original color over 0.5 seconds after the first transition
	tween.tween_property(player.player_sprite, "modulate", Color(1, 1, 1), invulnerable_duration/2)

func _on_player_stunned( _hurt_box: HurtBox ) -> void:
	hurt_box = _hurt_box
	state_machine.ChangeState( self )
	pass
