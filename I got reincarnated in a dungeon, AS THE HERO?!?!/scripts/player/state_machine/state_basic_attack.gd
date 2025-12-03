class_name StateBasicAttack extends State

@export_range(1, 20, 0.5) var decelerate_speed: float = 5.0

@onready var idle: StateIdle = $"../Idle"
@onready var walk: StateWalk = $"../Walk"

@onready var attack_animation: AnimationPlayer = $"../../Player Sprite/AnimationPlayer"
@onready var sword_swoosh: AnimationPlayer = $"../../Player Sprite/Sword Swoosh/AnimationPlayer"
@onready var basic_hurt_box: HurtBox = $"../../Player Sprite/Sword Swoosh/BasicHurtBox"

@export var state_animation_duration: float = 0.3

var isAttacking: bool = false
var _timer: float = 0.0

func Init() -> void:
	attack_animation.animation_finished.connect( EndAttack )

func Enter() -> void:
	_timer = state_animation_duration
	player.UpdateAnimation('basic-attack')
	sword_swoosh.play( 'basic-attack-' + player.AnimationDirection() )
	
	isAttacking = true
	
	await get_tree().create_timer(0.075).timeout
	if isAttacking:
		basic_hurt_box.monitoring = true
	pass
	
func Exit() -> void:
	
	isAttacking = false
	basic_hurt_box.monitoring = false
	pass
	
func Process( _delta: float ) -> State:
	_timer -= _delta
	if _timer <= 0:
		isAttacking = false
	player.velocity -= player.velocity * decelerate_speed * _delta
	if isAttacking == false:
		
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
func Physics( _delta: float ) -> State:
	return null
	
func HandleInput( _event: InputEvent ) -> State:
	return null

func EndAttack( _newAnimName: String ) -> void:
	isAttacking = false
