class_name ItemData extends Resource


@export var name: String = ''
@export_multiline var description: String = ''
@export var price: int = 20
@export var price_multiplier: float = 1.3
@export var max_price: int = 40
@export var texture: Texture2D

@export_category("Item Use Effects")
@export var effects: Array[ ItemEffect ]

func use( item_data: ItemData ) -> bool:
	if effects.size() == 0:
		return false
		
	for e in effects:
		if e:
			e.use( item_data )
		
	return true

func update_price():
	price = clampi( price * price_multiplier, price, max_price )
