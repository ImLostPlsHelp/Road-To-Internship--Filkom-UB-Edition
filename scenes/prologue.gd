extends Node2D

# Referensi script minigame (opsional, biar rapi aja)
# Pastikan node minigame kamu ada di scene ini seperti yang kita buat sebelumnya
@onready var qte_game = $QTE_Overlay
@onready var email_game = $KotakEmail

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	var timeline_awal = preload("res://timeline/timeline_start.dtl")
	Dialogic.start(timeline_awal)

func _on_dialogic_signal(argument: String):
	if argument == "restart_game":
		print("Mereset Game...")
		get_tree().reload_current_scene()
