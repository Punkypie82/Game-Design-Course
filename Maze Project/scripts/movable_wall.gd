extends RigidBody2D

@export var puzzle: Container
@export var puzzle_name: String
@onready var panel_gui: Control = %PanelGUI
@onready var label: Label = %Player/Label
@onready var player: CharacterBody2D = %Player
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var detection_zone: Area2D = $DetectionZone
@export var canTabOut = true

var playerInDetectionZone = false

func _init() -> void:
	Global.success.connect(_on_success)
	Global.fail.connect(_on_fail)

func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		label.visible = true
		playerInDetectionZone = true

func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player'):
		label.visible = false
		if is_instance_valid(puzzle):
			puzzle.visible = false
		playerInDetectionZone = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("OpenPanel") and playerInDetectionZone:
		if panel_gui.isOpen and canTabOut:
			panel_gui.close()
		else:
			panel_gui.open()
			puzzle.visible = true

func _on_success(name: String) -> void:
	if name == puzzle_name:
		label.visible = false
		panel_gui.close()
		puzzle.queue_free()
		animated_sprite.play('fall')
		
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 0.2
		add_child(timer)
		timer.start()
		await timer.timeout
		
		collider.queue_free()
		detection_zone.queue_free()

func _on_fail(name: String) -> void:
	if name == puzzle_name:
		label.visible = false
		panel_gui.close()
		puzzle.queue_free()
		detection_zone.queue_free()
