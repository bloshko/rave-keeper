extends Control

@onready var replay_button = $Button2
@onready var main_menu = $/root/Mainmenu
@onready var high = $Score2
@onready var yourscore = $Score

func _ready() -> void:
	replay_button.pressed.connect(back)
	$Button.pressed.connect(func(): 
		$"/root/Mainmenu".back()
		visible = false
	)

func blublub(score):
	yourscore.text = str(score)

	if GameplayData.hardcore:
		if score > Highschoolmanager.save.hard_score:
			Highschoolmanager.save.hard_score = score
			Highschoolmanager.save.save()
		high.text = str(Highschoolmanager.save.hard_score) 
	else:
		if score > Highschoolmanager.save.normal_score:
			Highschoolmanager.save.normal_score = score
			Highschoolmanager.save.save()
		high.text = str(Highschoolmanager.save.normal_score)

	visible = true

func back():
	for child in main_menu.find_child('GameRoot').get_children():
		child.queue_free()
	main_menu.load_game()
	visible = false
