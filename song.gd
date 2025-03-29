extends Control

@onready var qrcode = $MarginContainer/qrcode
@onready var code_label = $ColorRect2/scanthecode

var text = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var img_texture
	var file
	if Global.current_song == 0:
		img_texture = load("res://qrcodes/placeholder.png")
		file =  FileAccess.open("res://lyrics/callmemaybe.txt", FileAccess.READ)
		
	qrcode.texture = img_texture
	text = file.get_as_text()
	print(text)

func players_joined():
	code_label.visible = false
	qrcode.visible = false

	#while not f.eof_reached(): # iterate through all lines until the end of file is reached
		#var line = f.get_line()
		#line += " "
		#print(line + str(index))
#
		#index += 1
	#f.close()
	#return
