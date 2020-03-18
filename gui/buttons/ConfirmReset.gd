extends Control

func _ready() -> void:
	$Reset.visible = false

func _on_Confirm_visibility_changed() -> void:
	$Confirm/HBoxContainer/Cancel.grab_focus()
