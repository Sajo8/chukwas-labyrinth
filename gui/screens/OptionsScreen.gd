extends Control

func _ready():
	$MainMenu.grab_focus()

	# if it's not already disabled (ie, they have all the dlc)
	# then check the server to see if DLCs are currently enabled
	if not $Buttons/DLC.disabled:
		$Buttons/DLC.text = "Loading DLC..."
		$Buttons/DLC.disabled = true

		var err = $CheckDLCEnabled.request("https://testsajoeexpress.netlify.com/.netlify/functions/server/trtlapps/getDlcEnabled")
		if err != OK:
			$Buttons/DLC.text = "DLC currently disabled"
			$Buttons/DLC.disabled = true

func _on_CheckDLCEnabled_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var json_result = JSON.parse(body.get_string_from_utf8()).result
	if json_result['result']:
		$Buttons/DLC.text = "Buy DLC"
		$Buttons/DLC.disabled = false
	else:
		make_dlc_disabled()

func make_dlc_disabled():
	$Buttons/DLC.text = "DLC currently disabled"
	$Buttons/DLC.disabled = true
