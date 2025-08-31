extends Node

func _ready() -> void:
	$Menu/Button.pressed.connect(load_game)

func load_game():
	var game = load("res://scenes/main.tscn").instantiate()
	$GameRoot.add_child(game)
	$Menu.visible = false
	$FadeIn.visible = true
	var music_tween = create_tween()
	music_tween.tween_property($Menu/AudioStreamPlayer, 'volume_linear', 0, 8)
	music_tween.chain().tween_callback(func(): $Menu/AudioStreamPlayer.stop())
	var fade_tween = create_tween()
	fade_tween.tween_property($FadeIn, 'modulate', Color.TRANSPARENT, 5)
