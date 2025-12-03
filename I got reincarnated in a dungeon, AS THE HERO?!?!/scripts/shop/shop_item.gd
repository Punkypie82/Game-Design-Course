@tool
class_name ShopItem extends PanelContainer

@export var item_type: String
@export var item_data: ItemData: set = _set_item_data

@onready var texture: TextureRect = $HBoxContainer/MarginContainer/Texture
@onready var header: Label = $HBoxContainer/MarginContainer2/VBoxContainer/Header
@onready var description: Label = $HBoxContainer/MarginContainer2/VBoxContainer/Description
@onready var button: Button = $HBoxContainer/MarginContainer2/VBoxContainer/Button

func _ready() -> void:
	texture.texture = item_data.texture
	header.text = item_data.name
	description.text = item_data.description
	button.text = str( item_data.price )

func _process(delta: float) -> void:
	pass
	
func _set_item_data( value: ItemData ) -> void:
	item_data = value
	
func _on_button_pressed() -> void:
	if item_data:
		if PlayerManager.player.UpdateCash( -1 * item_data.price ):
			PlayerManager.INVENTORY_DATA.add_item( item_data )
			item_data.update_price()
			button.text = str( item_data.price )
			
