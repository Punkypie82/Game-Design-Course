class_name Slime extends Enemy

@export var HP: int = 30

var enemy_type: String = 'slime'
var direction: Vector2 = Vector2.ZERO
var cardinal_direction: Vector2 = Vector2.DOWN
var player: Player
var invulnerable: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprites: Node2D = $Sprites
@onready var enemy_state_machine = $EnemyStateMachine
@onready var aggro: EnemySlimeStateAggro = $EnemyStateMachine/Aggro

func _ready() -> void:
	enemy_state_machine.Initialize( self )
	player = PlayerManager.player
	is_slain_data.data_loaded.connect( set_enemy_state )
	set_enemy_state()

func set_enemy_state() -> void:
	is_slain = is_slain_data.value
	if is_slain:
		queue_free()
	pass

func _process(_delta: float) -> void:
	pass

func SetDirection( _new_direction: Vector2 ) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
		
	var new_direction: Vector2 = cardinal_direction
	
	if direction.y == 0:
		new_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	if direction.x == 0:
		new_direction = Vector2.UP if direction.y < 0 else Vector2.DOWN
		
	if new_direction == cardinal_direction:
		return false
	
	cardinal_direction = new_direction
	DirectionChanged.emit( _new_direction )
	sprites.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true
	
func UpdateAnimation( state: String ) -> void:
	animation_player.play( state + '-' + AnimationDirection())
	
func AnimationDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return 'down'
	elif cardinal_direction == Vector2.UP:
		return 'up'
	else:
		return 'side'

func _physics_process( _delta: float ) -> void:
	move_and_slide()

func _on_hit_box_damaged( hurt_box: HurtBox ) -> void:
	if invulnerable:
		return
	HP -= hurt_box.damage
	if HP <= 0:
		enemy_slain.emit( hurt_box )
	else:
		enemy_stunned.emit( hurt_box ) 
