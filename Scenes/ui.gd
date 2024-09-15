extends CanvasLayer

@onready var pause_menu: Control = $PauseMenu
@onready var ending_menu: Control = $EndScreenMenu

var is_finished = false

func _ready() -> void:
	pause_menu.hide()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if is_finished:
			return

		if not get_tree().paused:
			pause_menu.show()
			get_tree().paused = true
			Audiomanager.stop_all_sfx()
		else:
			pause_menu.hide()
			get_tree().paused = false


func finish_game(is_victory, enemies_killed, weapons_sold) -> void:
	Audiomanager.stop_all_sfx()
	ending_menu.show()
	is_finished = true
	get_tree().paused = true

	if is_victory:
		ending_menu.change_endscreen_text("Victory!", "You have survived all 3 waves of enemies. \nYou killed " + str(enemies_killed) + " enemies and made " + str(weapons_sold) + " swords.")
	else:
		ending_menu.change_endscreen_text("Defeat", "The village has been overrun by the enemy. \nYou killed " + str(enemies_killed) + " enemies and made " + str(weapons_sold) + " swords.")
