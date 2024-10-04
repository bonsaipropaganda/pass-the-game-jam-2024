## This serves as an example of an enemy, although it does not actually attack you
## Other enemies can inherit this or whatever works best
class_name BaseEmemy extends Node2D

var hp = 2

func _ready():
	SignalBus.enemy_spawned.emit()


func take_damage(_hp_loss:int):
	hp -= 1
	if hp > 0:
		$AnimationPlayer.play("take_damage")
		await $AnimationPlayer.animation_finished
	else:
		$AnimationPlayer.play("die")
		await $AnimationPlayer.animation_finished
		SignalBus.enemy_died.emit()
		queue_free()


func move():
	pass


func attack_player():
	pass
