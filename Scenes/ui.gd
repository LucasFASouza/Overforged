extends CanvasLayer
@onready var pause_menu: Control = $PauseMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if not get_tree().paused:
			pause_menu.show()
			get_tree().paused = true
		else:
			pause_menu.hide()
			get_tree().paused = false
