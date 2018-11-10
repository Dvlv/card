extends Node2D


onready var attack_anim_player = $AttackAnim/AnimationPlayer
onready var summon_anim_player = $SummonAnim/AnimationPlayer

func position_connect_play_attack(pos, callback_owner, callback, animation):
	$AttackAnim.position = pos
	attack_anim_player.connect("animation_finished", callback_owner, callback)

	attack_anim_player.play(animation)


func disconnect_attack(match_logic):
	if attack_anim_player.is_connected("animation_finished", match_logic, "post_do_attack_face"):
		attack_anim_player.disconnect("animation_finished", match_logic, "post_do_attack_face")

	if attack_anim_player.is_connected("animation_finished", match_logic, "post_do_battle"):
		attack_anim_player.disconnect("animation_finished", match_logic, "post_do_battle")


func position_connect_play_summon(pos, callback_owner, callback, animation):
	$SummonAnim.position = pos
	summon_anim_player.connect("animation_finished", callback_owner, callback)

	summon_anim_player.play(animation)

func play_fusebox_animation_with_callback(animation, callback_owner, callback):
	$FuseboxAnimationPlayer.connect("animation_finished", callback_owner, callback)
	$FuseboxAnimationPlayer.play(animation)


func disconnect_fusebox_animations(callback_owner, callback):
	if $FuseboxAnimationPlayer.is_connected("animation_finished", callback_owner, callback):
		$FuseboxAnimationPlayer.disconnect("animation_finished", callback_owner, callback)

