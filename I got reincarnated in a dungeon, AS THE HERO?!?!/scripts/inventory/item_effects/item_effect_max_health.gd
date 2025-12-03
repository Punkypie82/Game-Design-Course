class_name ItemEffectMaxHealth extends ItemEffect

@export var max_heal_amount: int = 25
@export var heal_amount: int = 25

func use( item_data: ItemData ) -> void:
	PlayerManager.player.UpdateMaxHP( max_heal_amount )
	PlayerManager.player.UpdateHP( heal_amount )
	
