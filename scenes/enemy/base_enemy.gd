# This serves as an example of an enemy, although it does not actually attack you
# Other enemies can inherit this or whatever works best
extends Node2D
class_name BaseEmemy

var hp = 2

func take_damage(hp_loss:int):
	hp -= 1
	if hp > 0:
		$AnimationPlayer.play("take_damage")
		await $AnimationPlayer.animation_finished
	else:
		$AnimationPlayer.play("die")
		await $AnimationPlayer.animation_finished
		Global.emit_signal("enemy_died")
		queue_free()


func move():
	pass


func attack_player():
	pass
