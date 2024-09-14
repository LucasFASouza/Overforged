extends AnimatedSprite2D


func _on_animations_finished():
	if self.animation == "out" or self.animation == "out-stars":
		self.visible = false
