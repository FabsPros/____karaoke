extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_callmemaybe_pressed() -> void:
	Global.current_song = 0
	get_tree().change_scene_to_file("res://song.tscn")
