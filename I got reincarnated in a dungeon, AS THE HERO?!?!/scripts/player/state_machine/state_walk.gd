class_name StateWalk extends State

@export var SPEED: float = 400.0
@onready var idle: StateIdle = $"../Idle"
@onready var basic_attack: StateBasicAttack = $"../Basic Attack"

func Enter() -> void:
	player.UpdateAnimation('walk')
	pass
	
func Exit() -> void:
	pass
	
func Process( _delta: float ) -> State:
	if player.direction == Vector2.ZERO:
		return idle
		
	player.velocity = player.direction * SPEED
	if player.SetDirection():
		player.UpdateAnimation('walk')
		
	return null
	
func Physics( _delta: float ) -> State:
	return null
	
func HandleInput( _event: InputEvent ) -> State:
	if _event.is_action_pressed("basic_attack"):
		return basic_attack
	return null
