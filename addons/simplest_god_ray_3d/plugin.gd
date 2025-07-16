@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type(
		"SimplestGodRay3D",
		"Node3D",
		preload("res://addons/simplest_god_ray_3d/simplest_god_ray_3d.gd"),
		null
	)

func _exit_tree():
	remove_custom_type("SimplestGodRay3D")
