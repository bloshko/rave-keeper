extends Control

@onready var gpman = $"../../GameplayManager"
@onready var hbox = $HBoxContainer

func _ready() -> void:
	if not GameplayData.hardcore:
		self.visible = false
		return

	gpman.something_changed.connect(refresh)
	for child in hbox.get_children():
		child.modulate = Color.WHITE * 2

func refresh():
	var i = 0
	for child in hbox.get_children():
		if child.visible and gpman.fails > 4 - i:
			var tween = create_tween()
			tween.tween_property(child.get_child(0), 'scale', Vector2.ONE * .8, .1)
			tween.chain().tween_callback(func(): child.visible = false)
		i += 1
