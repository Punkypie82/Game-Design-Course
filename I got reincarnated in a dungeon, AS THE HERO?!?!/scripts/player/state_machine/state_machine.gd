class_name StateMachine extends Node

var states: Array[ State ]
var prev_state: State
var curr_state: State

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	ChangeState( curr_state.Process( delta ) )
	
func _physics_process(delta: float) -> void:
	ChangeState( curr_state.Physics( delta ) )
	
func _input(event: InputEvent) -> void:
	ChangeState( curr_state.HandleInput(event) )
	
func Initialize( _player: Player ) -> void:
	states = []
	
	for c in get_children():
		if c is State:
			states.append(c)
			
	if states.size() == 0:
		return
			
	states[0].player = _player
	states[0].state_machine = self
	
	for state in states:
		state.Init()
	
	ChangeState( states[0] )
	process_mode = Node.PROCESS_MODE_INHERIT
	
func ChangeState( new_state: State ) -> void: 
	if new_state == null || new_state == curr_state:
		return
	
	if curr_state:
		curr_state.Exit()
	
	prev_state = curr_state
	curr_state = new_state
	curr_state.Enter()
