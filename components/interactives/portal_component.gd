extends Node2D


@export var PortalTarget: Node2D


func _get_configuration_warning():
	if not PortalTarget:
		return 'PortalTarget not set'
	return ''


func start():
	Globals.player_node.global_position = PortalTarget.global_position