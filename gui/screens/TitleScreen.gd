extends Control

func _ready():
	$Menu/CenterRow/LeftRow/Buttons/PlayButton.grab_focus()
	Globals.load_save()