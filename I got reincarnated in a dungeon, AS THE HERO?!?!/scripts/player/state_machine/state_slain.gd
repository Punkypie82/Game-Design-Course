class_name StateSlain extends State

@onready var walk: StateWalk = $"../Walk"
@onready var basic_attack: StateBasicAttack = $"../Basic Attack"

func Init() -> void:
	player.player_slain.connect( _on_player_slain )
	pass

func Enter() -> void:
	player.invulnerable = true
	player.UpdateAnimation( 'slain' )
	player.animation_player.animation_finished.connect( _on_animation_finished )

func Exit() -> void:
	pass
	
func Process( _delta: float ) -> State:
	return null
	
func Physics( _delta: float ) -> State:
	return null
	
func HandleInput( _event: InputEvent ) -> State:
	return null
	
func _on_animation_finished( _a: String ) -> void:
	player.invulnerable = false
	SaveManager.load_game( false )
	state_machine.ChangeState(player.idle)

func _on_player_slain() -> void:
	player.state_machine.ChangeState( self )
