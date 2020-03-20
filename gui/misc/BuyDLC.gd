extends Control

"""
There's a lot going on in this file, here's an attempt to map out what happens

At the start, some labels are hidden. These will only be shown later
The player clicks the continue button (goes to _on_continue_level_pressed())
-> we show a label saying it's loading
-> we make a HTTP request to create a new account (testing purposes: grab a known account) (calls get_account_info(), which in turn leads to _on_First_HTTPRequest_request_completed())
-> we show the user the address to deposit to (w/ the labels hidden previously and stuff

Then, we check if the account we made has the required amount (some of this is done server-side) (done in check_if_done() and _on_http_request_completed())
-> check_if_done() sleeps for x amt of seconds before checking each time
-> if it's not done we just call check_if_done() again
-> if it is, we call received_transaction()

When the player clicked continue, we also started a 30 minute timer.
If the tx is not received by then, then we stop checking periodically, tell them and show them the buttons again
"""

var accId
var check_balance = false
var timed_out = false

func _ready() -> void:
	$Level/TextEdit.hide()
	$Level/Label3.hide()
	$Level/Timer.hide()
	$Level/MainMenu.hide()

	######################### TEMP
	accId = "zPnQGKNmagxSXfm8i83A"

func _process(delta: float) -> void:
	if not check_balance:
		return
	# Get time left in seconds and round it to an int
	var time_left = $ThirtyMinTimer.get_time_left()
	time_left = round(time_left)
	time_left = int(time_left)

	# Get minutes remaining
	var time_left_m = time_left / 60
	time_left_m = round(time_left_m)

	# Get seconds remaining
	var time_left_s = time_left % 60

	# Make str of remaining time: "3m 37s"
	var time_left_m_s = str(time_left_m) + "m " + str(time_left_s) + "s"

	# Make full text
	var label_text = "Remaining Time: " + time_left_m_s

	# Assign new text
	$Level/Timer.text = label_text

func _on_continue_level_pressed() -> void:
	$Level/HBoxContainer.visible = false
	$Level/Label2.visible = true
	if timed_out: # reset the label to where it was if we timed out and moved it
		$Level/Label3.rect_position.y += 250
		timed_out = false

	$Level/Label3.rect_position.y -= 150
	$Level/Label3.text = "Loading, this may take a while"
	$Level/Label3.visible = true

	var first_http = HTTPRequest.new()
	add_child(first_http)
	first_http.connect("request_completed", self, "_on_First_HTTPRequest_request_completed")
	get_account_info(first_http)

func get_account_info(http_node):
	var headers = ["Content-Type: application/json"]

	################### temp
	var data = JSON.print({
		"accountId": accId
	})

	http_node.request(
		"https://testsajoeexpress.netlify.com/.netlify/functions/server/trtlapps/getAccount",
		headers,
		true,
		HTTPClient.METHOD_POST,
		data
	)
	# https://testsajoeexpress.netlify.com/.netlify/functions/server/trtlapps/newAccount

func _on_First_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:

	var json_result = JSON.parse(body.get_string_from_utf8()).result
	accId = json_result['accountId']
	var address = json_result['address']

	$Level/Label3.rect_position.y += 150
	$Level/Label3.text = """Note: after you send the deposit, it may take a while for it to register here!

	STATUS: Waiting for deposit, checking periodically..."""

	$Level/TextEdit.visible = true
	$Level/TextEdit.text = address

	$Level/Label3.visible = true

	$ThirtyMinTimer.start()
	check_balance = true
	$Level/Timer.visible = true
	check_if_done()

func check_if_done():
	if not check_balance:
		return
	yield(get_tree().create_timer(10), "timeout")
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self,
	"_on_http_request_completed")

	var headers = ["Content-Type: application/json"]
	var data = JSON.print({
		"accountId": accId
	})

	http.request(
		"https://testsajoeexpress.netlify.com/.netlify/functions/server/trtlapps/checkIfReceived",
		headers,
		true,
		HTTPClient.METHOD_POST,
		data
	)

func _on_http_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	var json_body = body.get_string_from_utf8()
	print(typeof(json_body))
	var json_result = JSON.parse(json_body)
	json_result = json_result.result
	print(json_result)
	var txReceivedResult = json_result['result']
	var txLocked = json_result['locked']
	if (txReceivedResult):
		if (txLocked):
			$Level/Label3.text = """Note: after you send the deposit, it may take a while for it to register here!

			Status: Deposit received! Waiting for network confirmation.."""
		else:
			received_transaction()
	check_if_done() # either we havent received the deposit or it's not confirmed

func received_transaction():
	$Level/TextEdit.hide()
	$Level/Label3.hide()
	$Level/Timer.hide()
	$ThirtyMinTimer.stop()
	$Level/Label2.align = $Level/Label2.ALIGN_CENTER
	$Level/Label2.text = """
	
	
	deposit received and confirmed!
	
	your dlc has been unlocked!
	
	enjoy!
	"""
	$Level/MainMenu.show()
	$Level/MainMenu.grab_focus()

func _on_30MinTimer_timeout() -> void:
	$Level/Label2.visible = false
	$Level/TextEdit.visible = false
	$Level/Label3.rect_position.y -= 250
	$Level/Label3.text = "You've timed out! No deposit has been received in 30 minutes. Please click the \"Continue\" button to try again"
	$Level/HBoxContainer.visible = true
	check_balance = false
	timed_out = true
	$Level/Timer.visible = false

# Unrelated to most logic in this file
# This function simply grabs focus of a button when it turns visible
func _on_Buy_about_to_show() -> void:
	$Buy/HBoxContainer/cancel.grab_focus()
