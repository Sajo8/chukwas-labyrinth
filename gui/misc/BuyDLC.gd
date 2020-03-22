extends Control

"""
There's a lot going on in this file, here's an attempt to map out what happens

At the start, some labels are hidden. These will only be shown later
The player clicks the continue button (goes to _on_continue_level_pressed())
-> we show a label saying it's loading
-> we make a HTTP request to create a new account (testing purposes: grab a known account) (calls get_account_info(), which in turn leads to _on_First_HTTPRequest_request_completed())
-> we show the user the address to deposit to (w/ the labels hidden previously and stuff
-> we also request the QR code and show that too

Then, we check if the account we made has the required amount (some of this is done server-side) (done in check_if_done() and _on_http_request_completed())
-> check_if_done() sleeps for x amt of seconds before checking each time
-> if it's not done we just call check_if_done() again
-> if it is, we call received_transaction()

When the player clicked continue, we also started a 30 minute timer.
If the tx is not received by then, then we stop checking periodically, tell them and show them the buttons again
"""

var headers = PoolStringArray(["Content-Type: application/json"])
var accId
var check_balance = false
var timed_out = false

# in the initial step when the user chooses which dlc to go to
var considering_level = false
var considering_skin = false

# when the user confirms that he wants to buy. var set to true according to which consdering_* var is true
var buying_level = false
var buying_skin = false

signal successful_dlc_purchase(buying_level, buying_skin)

func _ready() -> void:
	$PurchaseWindow/TextEdit.hide()
	$PurchaseWindow/Label3.hide()
	$PurchaseWindow/Timer.hide()
	$PurchaseWindow/MainMenu.hide()

	self.connect(
		"successful_dlc_purchase",
		get_node("/root/Globals"),
		"_on_successful_dlc_purchase"
	)

	######################### TEMP
	accId = "ORHHntz3KLG5NW1u8DxL"

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
	$PurchaseWindow/Timer.text = label_text

func _on_continue_buy_pressed() -> void:
	if considering_level:
		buying_level = true
	if considering_skin:
		buying_skin = true
	begin_purchase()

func begin_purchase() -> void:
	$PurchaseWindow/HBoxContainer.visible = false
	$PurchaseWindow/Label2.visible = true
	if timed_out: # reset the label to where it was if we timed out and moved it
		$PurchaseWindow/Label3.rect_position.y += 250
		timed_out = false

	$PurchaseWindow/Label3.rect_position.y -= 150
	$PurchaseWindow/Label3.text = "Loading, this may take a while"
	$PurchaseWindow/Label3.visible = true

	var first_http = HTTPRequest.new()
	add_child(first_http)
	first_http.connect("request_completed", self, "_on_First_HTTPRequest_request_completed")
	get_account_info(first_http)

func get_account_info(http_node):
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
	var error = check_if_error(json_result)
	if error:
		return
	accId = json_result['accountId']
	var address = json_result['address']
	var qrCodeUrl = json_result['qrCode']

	$PurchaseWindow/TextEdit.text = address

	var qr_http = HTTPRequest.new()
	add_child(qr_http)
	qr_http.connect("request_completed", self, "_on_qr_http_request_completed")
	var err = qr_http.request(qrCodeUrl)
	if err != OK:
		show_error_message()
		return

func _on_qr_http_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	$PurchaseWindow/Label3.rect_position.y += 150
	$PurchaseWindow/Label3.text = """Note: after you send the deposit, it may take a while for it to register here!

	STATUS: Waiting for deposit, checking periodically..."""

	$PurchaseWindow/TextEdit.visible = true
	$PurchaseWindow/Label3.visible = true

	$ThirtyMinTimer.start()
	$PurchaseWindow/Timer.visible = true

	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	# ignore the qr code and begin requesting
	if error != OK:
		check_balance = true
		check_if_done()
		return

	var texture = ImageTexture.new()
	texture.create_from_image(image)
	$PurchaseWindow/TextureRect.texture = texture

	check_balance = true
	check_if_done()

func check_if_done():
	if not check_balance:
		return
	yield(get_tree().create_timer(30), "timeout")
	var http = $MainHTTP

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

func _on_MainHTTP_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	var json_body = body.get_string_from_utf8()
	var json_result = JSON.parse(json_body).result

	# if error then just try again idk
	if str(json_result['err']) != "":
		check_if_done()

	var txReceivedResult = json_result['result']
	var txLocked = json_result['locked']
	if (txReceivedResult):
		if (txLocked):
			$PurchaseWindow/Label3.text = """Note: after you send the deposit, it may take a while for it to register here!

			Status: Deposit received! Waiting for network confirmation.."""
		else:
			received_transaction()
	check_if_done() # either we havent received the deposit or it's not confirmed

func received_transaction():
	check_balance = false
	$PurchaseWindow/TextEdit.hide()
	$PurchaseWindow/Label3.hide()
	$PurchaseWindow/Timer.hide()
	$ThirtyMinTimer.stop()

	$PurchaseWindow/Label2.align = $PurchaseWindow/Label2.ALIGN_CENTER
	$PurchaseWindow/Label2.text = """


	deposit received and confirmed!

	your dlc has been unlocked!

	enjoy!
	"""
	$PurchaseWindow/MainMenu.show()
	$PurchaseWindow/MainMenu.grab_focus()

	emit_signal("successful_dlc_purchase", buying_level, buying_skin)

func _on_30MinTimer_timeout() -> void:
	$PurchaseWindow/Label2.visible = false
	$PurchaseWindow/TextEdit.visible = false
	$PurchaseWindow/Label3.rect_position.y -= 250
	$PurchaseWindow/Label3.text = "You've timed out! No deposit has been received in 30 minutes. Please click the \"Continue\" button to try again"
	$PurchaseWindow/HBoxContainer.visible = true
	check_balance = false
	timed_out = true
	$PurchaseWindow/Timer.visible = false

func check_if_error(result) -> bool:
	print(result)
	if str(result['err']) != "":
		show_error_message()
		return true
	return false

# Only shown if the initial request fails. Other times, it just tries again
func show_error_message() -> void:
	$PurchaseWindow/TextEdit.hide()
	$PurchaseWindow/Label3.hide()
	$PurchaseWindow/Timer.hide()
	$ThirtyMinTimer.stop()

	$PurchaseWindow/Label2.text = "Hey!\n\nSorry, we seemed to have ran into an error. Please go back to the main menu and try again."
	$PurchaseWindow/MainMenu.show()
	$PurchaseWindow/MainMenu.grab_focus()

########

# These functions are unrelated to most logic in this file

# set the considering_* vars based on which initial button the user clicks
# under Buy/
func _on_level_pressed() -> void:
	considering_level = true
	considering_skin = false

func _on_skin_pressed() -> void:
	considering_skin = true
	considering_level = false

# if they cancel all DLC stuff then reset the vars
func _on_cancel_pressed() -> void:
	considering_skin = false
	considering_level = false
