class_name Player extends CharacterBody2D

#signal DirectionChanged( new_direction: Vector2 )
signal player_stunned( hurtbox: HurtBox )
signal player_slain()

var direction: Vector2 = Vector2.ZERO
var cardinal_direction: Vector2 = Vector2.DOWN

@onready var animation_player: AnimationPlayer = $"Player Sprite/AnimationPlayer"
@onready var state_machine: StateMachine = $"State Machine"
@onready var player_sprite: Sprite2D = $"Player Sprite"
@onready var hit_box: HitBox = $HitBox
@onready var basic_hurt_box: HurtBox = $"Player Sprite/Sword Swoosh/BasicHurtBox"
@onready var idle: StateIdle = $"State Machine/Idle"

@export var hp: int = 50
@export var max_hp: int = 100
var invulnerable: bool = false

const max_hp_limit: int = 500

var cash: int = 0

func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initialize(self)
	UpdateHP( 100 )

func _process(delta: float) -> void:
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")

func _physics_process(delta: float) -> void:
	move_and_slide()
	
func SetDirection() -> bool:
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
	#DirectionChanged.emit( new_direction )
	player_sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func UpdateAnimation( state: String ) -> void:
	animation_player.play( state + '-' + AnimationDirection())
	pass

func AnimationDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return 'down'
	elif cardinal_direction == Vector2.UP:
		return 'up'
	else:
		return 'side'
		
func UpdateMaxHP( delta: int) -> void:
	max_hp = clampi( max_hp + delta, 100, max_hp_limit)
	PlayerHud.update_hp( hp, max_hp )

func UpdateHP( delta: int ) -> void:
	hp = clampi( hp + delta, 0, max_hp )
	PlayerHud.update_hp( hp, max_hp )

func MakeInvulnerable( _duration: float ) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer( _duration ).timeout
	
	invulnerable = false
	hit_box.monitoring = true
	pass

func _on_hit_box_damaged( hurt_box: HurtBox ) -> void:
	if invulnerable:
		return
	UpdateHP( -hurt_box.damage )
	if hp > 0:
		player_stunned.emit( hurt_box )
	else:
		player_slain.emit()

func UpdateCash( delta: int ) -> bool:
	if cash + delta < 0:
		return false
	else:
		cash += delta
		PlayerHud.update_cash( cash )
		return true
