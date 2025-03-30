extends Control

@onready var qrcode = $MarginContainer/qrcode
@onready var code_label = $ColorRect2/scanthecode
@onready var firstLine = $MarginContainer/lines/MarginContainer/firstLine
@onready var secondLine = $MarginContainer/lines/MarginContainer2/secondLine
@onready var lines = $MarginContainer/lines
@onready var changeLineTimer = $changeLineTimer
@onready var audio = $AudioStreamPlayer
@onready var HTTPRequester = $HTTPRequest

var text = ""
var lineNumb = 0
var chunkNumb = 0
var wait_times = []
var json_data
var word1 = "__________"
var word2 = "__________"

# WEB STUFF

func test_connection():
	var tcp = StreamPeerTCP.new()
	var err = tcp.connect_to_host("httpbin.org", 443)  # Test HTTPS
	print("TCP Connection Result:", "✓ Success" if err == OK else "❌ Failed (Error %d)" % err)
	
	
func httprequest():
	HTTPRequester.request_completed.connect(_on_request_completed)
	var error = HTTPRequester.request("https://organic-fog-grapple.glitch.me/get-responses")
	if error != OK:
		push_error("Request failed")

func _ready() -> void:
	# WEB STUFF
	#print(HTTPRequester.request("https://httpbin.org/get"
	test_connection()
	# -------------------
	var img_texture
	var file
	if Global.current_song == 0:
		img_texture = load("res://qrcodes/placeholder.png")
		file =  FileAccess.open("res://lyrics/callmemaybe.txt", FileAccess.READ)
		audio.stream = load("res://songs/callmemaybe.mp3")
		wait_times = Global.callmemaybetimes
		
	qrcode.texture = img_texture
	text = file.get_as_text()
	#text = text.split("\r\n")
	#await get_tree().create_timer(3).timeout
	#players_joined()
	
## WEB STUFF
func _on_request_completed(result, response_code, headers, body):
	#var json = JSON.parse_string(body.get_string_from_utf8())
	#print(json)
	#if response_code == 200:
		#var json = JSON.parse_string(body.get_string_from_utf8())
		##print(json)
		#readJSON(json)
		##if json.error == OK:
			##print("Received data: ", json.result)
			### Process your data here
		##else:
			##print("JSON parse error")
	#else:
		#print("Request failed with code: ", response_code)
	if result == HTTPRequest.RESULT_SUCCESS and response_code == 200:
		# Convert response body to string
		var body_string = body.get_string_from_utf8()
		
		# Parse JSON to Dictionary
		var json = JSON.new()
		var parse_error = json.parse(body_string)
		
		if parse_error == OK:
			var data: Dictionary = json.get_data()
			# Now you can use it as a dictionary!
			#print(data["0"])  # Access like any dictionary
			print("success")
			json_data = data
		else:
			print("JSON Parse Error:", json.get_error_message(), "at line", json.get_error_line())
			print("Raw response:", body_string)
	else:
		print("Request failed. Result:", result, "Status:", response_code)
# --------------------------------

func players_joined():
	#readJSON()
	code_label.visible = false
	qrcode.visible = false
	changeLineTimer.wait_time = wait_times[0]
	changeLineTimer.start()
	lines.visible = true
	audio.play()
	
func readJSON(json):
	#var file = FileAccess.open("res://responses.json", FileAccess.READ)
	#assert(file.file_exists("res://responses.json"), "File doesn't exist")
	#
	#var json = file.get_as_text()
	var json_object = JSON.new()
	
	json_object.parse(json)
	print(json_object)
	
	json_data = json_object.data


func _on_change_line_timer_timeout() -> void: # USE REPLACE TO REPLACE
	# JSON PART
	print(chunkNumb)
	if json_data != null:
		if json_data.has(str(chunkNumb)):
			word1 = json_data.get(str(chunkNumb)).get("word1")
			word2 = json_data.get(str(chunkNumb)).get("word2")
		# --------
		var line = str(text.get_slice("\r\n", lineNumb))
		line = line.replace("__________", ("_"+word1+"_"))
		line = line.replace("._________", ("_"+word2+"_"))
		firstLine.text = line
		lineNumb += 1 
		if lineNumb < wait_times.size():
			changeLineTimer.wait_time = wait_times[lineNumb]
			changeLineTimer.start()
			if lineNumb % 5 == 0:
				chunkNumb += 1


func _on_fetch_pressed() -> void:
	httprequest()


func _on_start_pressed() -> void:
	players_joined()
