class_name ItemEffectSlimeCore extends ItemEffect

@export var conversion_rate: int = 10

func use( item_data: ItemData ) -> void:
	PlayerManager.player.UpdateCash( conversion_rate )
	pass
