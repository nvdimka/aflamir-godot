extends Node

func get_all_near_inkables() -> Array[Node]:
	return get_tree().get_nodes_in_group("inkables_near_player")

func get_focused_inkable() -> Node:
	var inkables = get_all_near_inkables()

	if (inkables.size() == 0):
		return null

	return inkables[inkables.find_custom(find_focused.bind())]


func find_focused(elem: Node) -> bool:
	return elem.is_focused
