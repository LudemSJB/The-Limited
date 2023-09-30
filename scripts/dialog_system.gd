extends Node2D

enum DialogActions {
	None = 0,
	CloseDialog = 1,
	NextScene = 2
}

@onready var rich_text_label = $Sprite2D/RichTextLabel
@onready var sprite_2d = $Sprite2D
@onready var face = $Sprite2D/face
@onready var face_position_1 = $Sprite2D/facePosition1
@onready var face_position_0 = $Sprite2D/facePosition0
@onready var dialog_position_0 = $dialogPosition0
@onready var dialog_position_1 = $dialogPosition1
@onready var dialog_position_2 = $dialogPosition2

@export var showDialogAtSceneStart : bool = true
@export var dialogsPath: String
@export var faces: Array[Texture]
@export var is_active: bool = true;

var current_dialog: int = 0
var dialogs: Array

var change_scene_after_dialog_close: bool = false
var close_dialog_after_dialog_close: bool = false

var root: Node

func _ready():
	loadDialogs()
	root = get_node("../..")
	if showDialogAtSceneStart:
		showText(dialogs[current_dialog])
	else:
		hideText()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_active:
		if Input.is_action_just_released("action_button"):
			if change_scene_after_dialog_close:
				root.emit_signal("change_to_next_scene")
				change_scene_after_dialog_close = false
				return
			if close_dialog_after_dialog_close:
				hideText()
				close_dialog_after_dialog_close = false
				return
			nextText()

func loadDialogs():
	var file = FileAccess.open(dialogsPath, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var obj = JSON.parse_string(content)
	if obj == null:
		print("couldn't parse json!")
	dialogs = obj

func nextText():
	print("nextText")
	current_dialog += 1
	if current_dialog < dialogs.size():
		showText(dialogs[current_dialog])

func hideText():
	sprite_2d.visible = false
	is_active = false

func showText(dialog):
	is_active = true
	# show new text in dialog
	sprite_2d.visible = true
	rich_text_label.clear()
	rich_text_label.append_text(dialog.text)
	
	# move dialog box position
	if dialog.has("dialog_position"):
		if dialog.dialog_position == 0:
			sprite_2d.position = dialog_position_0.position
		elif dialog.dialog_position == 1:
			sprite_2d.position = dialog_position_1.position
		elif dialog.dialog_position == 2:
			sprite_2d.position = dialog_position_2.position
	
	# change face and its position relative to dialog box
	if dialog.has("face"):
		face.visible = true
		face.texture = faces[dialog.face]
		if dialog.has("position"):
			if dialog.position == 0:
				sprite_2d.flip_h = false
				face.position = face_position_0.position
			else:
				sprite_2d.flip_h = true
				face.position = face_position_1.position
	else:
		face.visible = false
		
	if dialog.has("action"):
		var action = dialog.action
		print("action: ", action)
		if action == DialogActions.NextScene as int:
			change_scene_after_dialog_close = true
		elif action == DialogActions.CloseDialog as int:
			close_dialog_after_dialog_close = true
