extends CanvasLayer

signal NoteHit
signal NoteMiss
signal PlayerLoss
signal MiniGameEnded
signal StartMiniGame

@onready var music = $Music
@onready var sound_success = $sound_success
@onready var sound_misclick_fail = $sound_misclick_fail

@export var scoreToAdd = 15
@export var scoreToMinus = 5
@export var freeplay = false

var root: Node

func _ready():
	StartupMiniGame()


func hit_note():
	NoteHit.emit()
	if root != null:
		root.AddScore(scoreToAdd)
	sound_success.play()

# misclicked, no note on press area
func miss_note():
	NoteMiss.emit()
	if root != null:
		root.AddScore(-scoreToMinus)
		root.ShakeCamera()
	sound_misclick_fail.play()

func _on_end_minigame_area_entered(_area):
	MiniGameEnded.emit()
	if freeplay == false: root.MiniGameEnded()

func StartupMiniGame():
	root = get_tree().root.get_child(0)
	music.play()
	if root.name != "root":
		root = null
	else:
		root.MiniGameStarted()

func _on_start_mini_game():
	StartupMiniGame()

# note got past the press area
func _on_player_note_player_passed_note():
	if root != null:
		root.AddScore(-scoreToMinus)
