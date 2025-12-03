class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://scenes/inventory/inventory_slot.tscn")

@export var data: InventoryData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Inventory.shown.connect( update_inventory )
	Inventory.hidden.connect( clear_inventory )
	clear_inventory()
	data.changed.connect( on_inventory_changed )
	pass # Replace with function body.


func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()
		

func update_inventory() -> void:
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child( new_slot )
		new_slot.slot_data = s
		
	get_child( 0 ).grab_focus()

func on_inventory_changed() -> void:
	clear_inventory()
	update_inventory()
