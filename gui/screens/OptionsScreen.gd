extends Control

onready var dlc_level_button = get_node("Buttons/DLC/BuyDLC/Buy/HBoxContainer/level")
onready var dlc_skin_button = get_node("Buttons/DLC/BuyDLC/Buy/HBoxContainer/skin")

func _ready():
	$MainMenu.grab_focus()

	# if it's not already disabled (ie, they have all the dlc)
	# then check the server to see if DLCs are currently enabled
	if not $Buttons/DLC.disabled:
		dlc_level_button.text = "Loading DLC..."
		dlc_skin_button.text = "Loading DLC..."

		dlc_level_button.disabled = true
		dlc_skin_button.disabled = true

		var err = $CheckDLCEnabled.request("https://testsajoeexpress.netlify.com/.netlify/functions/server/trtlapps/getDlcEnabled")
		if err != OK:
			make_dlc_disabled()

func _on_CheckDLCEnabled_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var json_result = JSON.parse(body.get_string_from_utf8()).result
	if json_result['result']:
		dlc_level_button.text = "Level DLC"
		dlc_skin_button.text = "Skin DLC"

		dlc_level_button.disabled = false
		dlc_skin_button.disabled = false
	else:
		make_dlc_disabled()

func make_dlc_disabled():
	dlc_level_button.text = "DLC disabled"
	dlc_skin_button.text = "DLC disabled"

	dlc_level_button.disabled = true
	dlc_skin_button.disabled = true
