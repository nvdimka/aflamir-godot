extends Area2D

@export var InteractionComponent: Node2D
@export var FocusSprite: Sprite2D


func _get_configuration_warning():
	if not InteractionComponent:
		return 'InteractionComponent not set'
	if not FocusSprite:
		return 'FocusSprite not set'
	return ''


# var is_focused: bool
var is_focused := false:
	get:
		return is_focused
	set(val):
		is_focused = val
		if val:
			FocusSprite.focus()
		else:
			FocusSprite.highlight()


func _on_player_entered(_body: Node2D) -> void:
	FocusSprite.highlight()
	Globals.add_to_near_interactives(self)
	if Globals.get_all_near_interactives().size() == 1:
		self.is_focused = true


func _on_player_exited(_body: Node2D) -> void:
	self.is_focused = false
	FocusSprite.remove()
	Globals.remove_from_near_interactives(self)
	if Globals.get_focused_interactive() == null && Globals.get_all_near_interactives().size() > 0:
		var lastInteractive = Globals.get_all_near_interactives()[-1]
		lastInteractive.is_focused = true


func start():
	if InteractionComponent.has_method("start"):
		InteractionComponent.start()


func stop():
	if InteractionComponent.has_method("stop"):
		Globals.game_state = Globals.GameState.EXPLORATION
		InteractionComponent.stop()
