extends Node

var player_node: Player

enum GameState {EXPLORATION, INTERACTION, INVENTORY}
var game_state: GameState = GameState.EXPLORATION
