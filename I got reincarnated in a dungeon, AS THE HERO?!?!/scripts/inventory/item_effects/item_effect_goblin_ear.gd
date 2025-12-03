class_name ItemEffectGoblinEar extends ItemEffect

@export var conversion_rate: int = 100

func use( item_data: ItemData ) -> void:
	PlayerManager.player.UpdateCash( conversion_rate )
	pass
