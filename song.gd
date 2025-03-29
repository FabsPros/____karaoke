extends Control

@onready var qrcode = $MarginContainer/qrcode
@onready var code_label = $ColorRect2/scanthecode
@onready var firstLine = $MarginContainer/lines/MarginContainer/firstLine
@onready var secondLine = $MarginContainer/lines/MarginContainer2/secondLine
@onready var lines = $MarginContainer/lines
@onready var changeLineTimer = $changeLineTimer

var text = ""
var lineNumb = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var img_texture
	var file
	if Global.current_song == 0:
		img_texture = load("res://qrcodes/placeholder.png")
		file =  FileAccess.open("res://lyrics/callmemaybe.txt", FileAccess.READ)
		
	qrcode.texture = img_texture
	text = file.get_as_text()
	#text = text.split("\r\n")
	await get_tree().create_timer(1).timeout
	players_joined()

func players_joined():
	code_label.visible = false
	qrcode.visible = false
	changeLineTimer.start()
	lines.visible = true
	#print(text)


func _on_change_line_timer_timeout() -> void: # USE REPLACE TO REPLACE
	var line = str(text.get_slice("\r\n", lineNumb))
	line = line.replace("__________", ("_"+"WORD"+"_"))
	line = line.replace("._________", ("_"+"WORD2"+"_"))
	firstLine.text = line
	lineNumb += 1 
	line = str(text.get_slice("\r\n", lineNumb))
	line = line.replace("__________", ("_"+"WORD"+"_"))
	line = line.replace("._________", ("_"+"WORD2"+"_"))
	secondLine.text = line
	lineNumb += 1
	#text.remove_at(0)
	# SET NEW TIMER TIME AND NEW WORD AND WORD2
	changeLineTimer.start()
