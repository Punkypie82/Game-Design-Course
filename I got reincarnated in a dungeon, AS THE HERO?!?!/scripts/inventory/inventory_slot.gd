class_name InventorySlotUI extends Button

signal item_purchased( item: ItemData )

var slot_data: SlotData: set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var background_sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_rect.texture = null
	label.text = ""
	mouse_entered.connect( item_hover )
	mouse_exited.connect( item_unhover )
	pressed.connect( item_pressed )
	pass

func set_slot_data( value: SlotData ) -> void:
	background_sprite.frame = 0
	slot_data = value
	if slot_data == null:
		return
	texture_rect.texture = slot_data.item_data.texture
	label.text = str( slot_data.quantity )
	background_sprite.frame = 1
	pass

func item_hover() -> void:
	if slot_data != null:
		if slot_data.item_data != null:
			Inventory.update_item_description( slot_data.item_data.description )
	pass
	
func item_unhover() -> void:
	Inventory.update_item_description( "" )
	pass

func item_pressed() -> void:
	if slot_data:
		if slot_data.item_data:
			var was_used = slot_data.item_data.use( slot_data.item_data )
			if not was_used:
				return 
			slot_data.quantity -= 1
			label.text = str( slot_data.quantity )
	
