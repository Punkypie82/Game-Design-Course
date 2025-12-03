@tool
class_name ItemPickup extends CharacterBody2D

@export var item_data: ItemData : set = _set_item_data

@onready var area_2d: Area2D = $Area2D
@onready var texture_rect: TextureRect = $TextureRect

var set_width = 40

func _ready() -> void:
	_update_texture()
	if Engine.is_editor_hint():
		return
	area_2d.body_entered.connect( _on_body_entered )

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide( velocity * delta )
	if collision_info:
		velocity = velocity.bounce( collision_info.get_normal() )
	velocity -= velocity * delta * 4

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if item_data:
			if PlayerManager.INVENTORY_DATA.add_item( item_data ):
				item_picked_up()
	pass

func item_picked_up() -> void:
	area_2d.body_entered.disconnect( _on_body_entered )
	visible = false
	queue_free()
	pass

func _set_item_data( value: ItemData ) -> void:
	item_data = value
	_update_texture()
	pass

func _update_texture() -> void:
	if item_data and texture_rect:
		texture_rect.texture = item_data.texture
	pass
