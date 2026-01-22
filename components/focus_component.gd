extends Sprite2D


# func focus():
# 	self.texture = load("res://ui/icons/controls/gamepad_a.png")


# func unfocus():
# 	self.texture = load("res://ui/icons/controls/empty_round.png")


func remove():
	self.texture = null


func highlight():
	self.texture = load("res://ui/icons/controls/empty_round.png")


func focus():
	self.texture = load("res://ui/icons/controls/gamepad_a.png")


func _ready() -> void:
	remove()