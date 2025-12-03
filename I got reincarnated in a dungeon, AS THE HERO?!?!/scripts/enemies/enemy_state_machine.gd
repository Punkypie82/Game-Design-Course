class_name EnemyStateMachine extends Node

var states: Array[ EnemyState ]
var prev_state: EnemyState
var curr_state: EnemyState

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	
func _process(delta: float) -> void:
	ChangeState( curr_state.Process( delta ) )
	
func _physics_process(delta: float) -> void:
	ChangeState( curr_state.Physics( delta ) )
	
func Initialize( _enemy: Enemy ) -> void: 
	states = []

	for c in get_children():
		if c is EnemyState:
			states.append(c)
			
	for s in states:
		s.enemy = _enemy
		s.enemy_state_machine = self
		s.Init()
			
	if states.size() > 0:
		ChangeState( states[0] )
		process_mode = Node.PROCESS_MODE_INHERIT
	
func ChangeState( new_state: EnemyState ) -> void: 
	if new_state == null || new_state == curr_state:
		return
	
	if curr_state:
		curr_state.Exit()
	
	prev_state = curr_state
	curr_state = new_state
	curr_state.Enter()
