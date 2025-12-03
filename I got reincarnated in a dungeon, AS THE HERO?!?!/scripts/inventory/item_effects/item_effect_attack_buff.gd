class_name ItemEffectAttackBuff extends ItemEffect

@export var attack_buff_amount: int = 5

func use( item_data: ItemData ) -> void:
	PlayerManager.player.basic_hurt_box.damage += attack_buff_amount
