extends Node


func _ready() -> void:
	$Menu/Button.pressed.connect(load_game)
	$Menu/Button2.pressed.connect(change_mode)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		$Menu/Button.pressed.emit()
		
func change_mode():
	GameplayData.hardcore = not GameplayData.hardcore
	$Menu/Button2.text = "<- %s mode ->" % ("hardcore" if GameplayData.hardcore else "normal")

func load_game():
	var game = load("res://scenes/main.tscn").instantiate()
	$GameRoot.add_child(game)
	$Menu.visible = false
	$FadeIn.visible = true
	var music_tween = create_tween()
	music_tween.tween_property($Menu/AudioStreamPlayer, 'volume_linear', 0, 8)
	music_tween.chain().tween_callback(func(): $Menu/AudioStreamPlayer.stop())
	var fade_tween = create_tween()
	$FadeIn.modulate = Color.WHITE
	fade_tween.tween_property($FadeIn, 'modulate', Color.TRANSPARENT, 5)

func back():
	for child in $GameRoot.get_children():
		child.queue_free()
	$FadeIn.visible = false
	$Menu/AudioStreamPlayer.volume_linear = 1
	$Menu/AudioStreamPlayer.play()
	$Menu.visible = true
