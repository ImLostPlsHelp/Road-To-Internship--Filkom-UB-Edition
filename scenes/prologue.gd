# scenes/Prolog.gd
extends Node2D

# Hubungkan node dari scene ke script
@onready var dosen_sprite = $DosenSprite
# Pastikan node SFXPlayer sudah dibuat di scene tree!
# @onready var sfx_player = $SFXPlayer
@onready var dialogue_box = $DialogueBox

# Data cerita
var dialogue_data = [
	{"speaker": "Dosen", "sprite": "dosen_sinis", "text": "Kapan mau PKL? Udah mau lulus harusnya kamu ini.", "position": "right"},
	{"speaker": "Dosen", "sprite": "dosen_teriak", "text": "BURUAN DAFTAR PKL!!", "position": "right"},
	{"speaker": "Narator", "sprite": "hitam", "text": "Karakter utama bangun karena terkejut lalu kesiangan...", "position": "center"},
	{
		"speaker": "Player",
		"sprite": "mahasiswa_kaget",
		"text": "Aduh! Laptop masih nyala... SIAM! Aku harus...",
		"position": "left",
		"choices": [
			{"text": "[✓] Tambah PKL di SIAM", "id": "pilih_benar"},
			{"text": "[✗] Nanti aja deh", "id": "pilih_salah"}
		]
	}
]

var current_dialogue_index = 0

func _ready():
	# Pastikan dialogue_box tidak null sebelum connect
	if dialogue_box:
		dialogue_box.choice_made.connect(_on_user_choice)
		display_current_dialogue()
	else:
		print("ERROR: Node DialogueBox tidak ditemukan!")

func _input(event):
	if event.is_action_pressed("ui_accept") and not dialogue_box.is_showing_choices():
		current_dialogue_index += 1
		display_current_dialogue()

func display_current_dialogue():
	if current_dialogue_index >= dialogue_data.size():
		print("Cerita di scene ini habis.")
		return

	var data = dialogue_data[current_dialogue_index]

	# Logika Sprite (Sederhana)
	if data.sprite == "dosen_sinis":
		dosen_sprite.show()
		# Anda bisa atur texture di sini jika punya banyak file
	elif data.sprite == "dosen_teriak":
		dosen_sprite.show()
	else:
		dosen_sprite.hide()

	# Tampilkan teks dialog
	# Kita kirim data.position ke parameter 'tata_letak'
	dialogue_box.show_dialogue(data.speaker, data.text, data.position)

	# Jika ada pilihan, tampilkan pilihan
	if data.has("choices"):
		dialogue_box.show_choices(data.choices)

func _on_user_choice(choice_id):
	if choice_id == "pilih_benar":
		print("Pilihan Benar! Lanjut ke Chapter 1")
		# GlobalState.go_to_scene("res://scenes/Chapter1.tscn")
		
	elif choice_id == "pilih_salah":
		print("Pilihan Salah! JUMPSCARE")
		dosen_sprite.show()
		# Efek getar atau suara bisa ditambahkan di sini
		await get_tree().create_timer(1.0).timeout
		GlobalState.reload_current_scene()
