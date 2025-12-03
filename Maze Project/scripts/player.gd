extends CharacterBody2D

const SPEED = 4500.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Tracks the last movement direction for idle animations
var last_direction: Vector2 = Vector2.ZERO
var isPanleOpen = false

func _physics_process(delta: float) -> void:
	if isPanleOpen:
		pass
	else:
		var direction_x := Input.get_axis("ui_left", "ui_right")
		var direction_y := Input.get_axis("ui_up", "ui_down")
		
		# Determine movement direction and play animations
		if direction_x > 0:
			animated_sprite.play('walk_right')
			last_direction = Vector2.RIGHT
		elif direction_x < 0:
			animated_sprite.play('walk_left')
			last_direction = Vector2.LEFT
		elif direction_y > 0:
			animated_sprite.play('walk_front')
			last_direction = Vector2.DOWN
		elif direction_y < 0:
			animated_sprite.play('walk_back')
			last_direction = Vector2.UP
		else:
			# Play idle animations based on the last direction
			if last_direction == Vector2.RIGHT:
				animated_sprite.play('idle_right')
			elif last_direction == Vector2.LEFT:
				animated_sprite.play('idle_left')
			elif last_direction == Vector2.DOWN:
				animated_sprite.play('idle_front')
			elif last_direction == Vector2.UP:
				animated_sprite.play('idle_back')

		# Apply movement
		if direction_x:
			velocity.x = direction_x * SPEED * delta
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta)
			
		if direction_y:
			velocity.y = direction_y * SPEED * delta
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED * delta)

		move_and_slide()

func _on_panel_gui_closed() -> void:
	isPanleOpen = false


func _on_panel_gui_opened() -> void:
	isPanleOpen = true
