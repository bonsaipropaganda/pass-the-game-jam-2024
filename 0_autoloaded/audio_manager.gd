extends Node

@onready var _music_player:AudioStreamPlayer = $MusicPlayer
@onready var _sfx_player:AudioStreamPlayer = $SfxPlayer

@onready var _music_playback:AudioStreamPlaybackPolyphonic = _music_player.get_stream_playback()
@onready var _sfx_playback:AudioStreamPlaybackPolyphonic = _sfx_player.get_stream_playback()



### Audio samples (songs and sfx) are preloaded here.
### If you add a sample, the corresponding enum must be updated aswell,
### so the autocompletion will work in all scripts

#   music   #
@export var streams_songs:Array[AudioStream]

# careful: put songs in the same order in the enum as in the array!
enum song_enum {
	STOP = -1 ,# keep at the beginning
	
	MENU,
	GAMEPLAY_1,
	
	SONG_MAX # keep at the end
	}


#   sfx   #

@export var streams_sfx:Array[AudioStream]

# careful: put songs in the same order in the enum as in the array!
enum sfx_enum {
	CHEST_OPEN,
	DAMAGE,
	HEARTBEAT,
	DOOR_OPEN,
	DOOR_SLAM,
	MONEY,
	ATTACK,
	FOOTSTEPS,
	BUTTON,
	SELECT,
	KILL,
	PAPER_1,
	PAPER_2,
	
	SFX_MAX # keep at the end
	}


func _ready() -> void:
	if len(streams_songs) != song_enum.SONG_MAX:
		push_error (
			"
			song_enum is not the same length as streams_songs!
			\tIf you added songs, please give them a name in the script's 'song_enum'.
			\tif you removed songs, please remove them from the enum accordingly.
			\totherwise it will result in unwanted behaviors.
		")
	if len(streams_sfx) != sfx_enum.SFX_MAX:
		
		push_error (
			"
			sfx_enum is not the same length as streams_sfx!
			\tIf you added sfx, please give them a name in the script's 'sfx_enum'.
			\tif you removed sfx, please remove them from the enum accordingly.
			\totherwise it will result in unwanted behaviors.
		")


##### #####

var current_music_stream_index:int = -1
var tween:Tween # declared outside to prevent concurrency
## triggers the music transition.
## [param song] must be a member of [enum song_enum]
## [param transition_time] is optional and sets the time of crossfade.
## If you want to stop the music, use [constant song_num.STOP].
## This function is async. You can await it and it will return once the transition is finished.

func music_transition_to(song:song_enum, transition_time:float = 0.8) -> void:
	tween = get_tree().create_tween().set_parallel(true)
	
	var new_stream_index:int
	# if nothing is playing right now
	if current_music_stream_index == song_enum.STOP:
		if song == song_enum.STOP: return;
		
		new_stream_index = _music_playback.play_stream(streams_songs[song], 0, -80)
		
		#fade in the new one
		tween.tween_method(
			(func (vol:float): _music_playback.set_stream_volume(new_stream_index, vol)),
			-80,
			0,
			transition_time
		).set_trans(Tween.TRANS_EXPO)
	
	# if we wanna stop the music
	elif song == song_enum.STOP:
		if current_music_stream_index == -1 : return
		#fade out the current one
		tween.tween_method(
			(func (vol:float): _music_playback.set_stream_volume(current_music_stream_index, vol)),
			0,
			-80,
			transition_time
		).set_trans(Tween.TRANS_EXPO)
		
	else:
		new_stream_index = _music_playback.play_stream(streams_songs[song], 0, -80)
		
		#fade out the current one
		tween.tween_method(
			(func (vol:float): _music_playback.set_stream_volume(current_music_stream_index, vol)),
			0,
			-80,
			transition_time
		).set_trans(Tween.TRANS_EXPO)
		
		#fade in the new one
		tween.tween_method(
			(func (vol:float): _music_playback.set_stream_volume(new_stream_index, vol)),
			-80,
			0,
			transition_time
		).set_trans(Tween.TRANS_EXPO)
		
	tween.play()
	await tween.finished
	if current_music_stream_index != -1: _music_playback.stop_stream(current_music_stream_index)
	current_music_stream_index = new_stream_index if song != song_enum.STOP else -1
	return


# there is no get_stream_volume for AudioStreamPlaybackPolyphonic.
# this is a workaround to keep track of sfx volumes
# keys are stream ids, valus are volume
# we never clear the keys. It shouldn't matter since we always access playback aswell
# so it will error on invalid sid
var _sfx_volumes:Dictionary = {}

## plays a SFX
## returns an identifier to be used if needed in other sfx functions
## careful! While [param pitch_variation] goes both ways, [volume_variation] goes only down.

func sfx_play(sound:sfx_enum, pitch_variation:float = 0.12,  volume:float = 0.0, volume_variation:float = 0.0) -> int:
	
	var sid:int =  _sfx_playback.play_stream(
		streams_sfx[sound],
		0.0,
		volume + randf_range(-volume_variation, 0.0),
		1.0 + randf_range(-pitch_variation, pitch_variation)
	)
	_sfx_volumes[sid] = volume
	return sid

## transitions smoothly to volume for the sfx designated by the stream id
## returns when finished. You can await it if needed
func sfx_set_volume(sid:int, volume:float, transition_time:float = 0.4) -> void:
	
	#this tween is scoped inside the function.
	#Changing a, sfx volume twice at the same time may do weird things.
	#if you need to do it, use transition_time = 0
	
	if transition_time == 0:
		_sfx_playback.set_stream_volume(sid, volume)
		return
	
	var volume_tween = get_tree().create_tween()
	
	volume_tween.tween_method(
		(func (vol:float): _sfx_playback.set_stream_volume(sid, vol)),
		_sfx_volumes[sid],
		-80,
		transition_time
	).set_trans(Tween.TRANS_EXPO)
	volume_tween.play()
	await volume_tween.finished
	_sfx_playback.stop_stream(sid)
	return

func sfx_stop(sid:int, transition_time:float = 0.4) -> void:
	
	await sfx_set_volume(sid, -80.0, transition_time)
	_sfx_playback.stop_stream(sid)
	return



var music_volume_tween:Tween;

## transitions smoothly to volume
## returns when finished. You can await it if needed
func music_set_volume(vol:float, transition_time:float= 0.3) -> void:

	
	music_volume_tween = get_tree().create_tween()
	
	music_volume_tween.tween_property(
		_music_player,
		"volume_db",
		vol,
		transition_time
		
	).set_trans(Tween.TRANS_EXPO)
	music_volume_tween.play()
	
	await music_volume_tween.finished
	return
