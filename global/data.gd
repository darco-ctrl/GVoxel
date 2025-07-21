extends Node

var world: Node3D
var player: CharacterBody3D

func _ready() -> void:
	world = get_tree().root.get_node("World")
