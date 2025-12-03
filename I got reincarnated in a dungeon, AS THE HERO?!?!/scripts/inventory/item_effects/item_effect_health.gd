class_name ItemEffectHealth extends ItemEffect

@export var heal_amount: int = 25

func use( item_data: ItemData ) -> void:
	item_data.price *= 0.4
	PlayerManager.player.UpdateHP( heal_amount )
