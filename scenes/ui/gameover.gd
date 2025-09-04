extends Control

@onready var replay_button = $Button2
@onready var main_menu = $/root/Mainmenu

func _ready() -> void:
	replay_button.pressed.connect(back)
	$Button.pressed.connect(func(): 
		$"/root/Mainmenu".back()
		visible = false
	)

func blublub(score):
	visible = true

func back():
	for child in main_menu.find_child('GameRoot').get_children():
		child.queue_free()
	main_menu.load_game()
	visible = false
