# ui/DialogueBox.gd
extends Control

# Sinyal ini akan kita kirim ke scene Prolog saat pemain memilih
signal choice_made(choice_id)

# Variabel ini akan muncul di Inspector.
@export var left_bubble_region: Rect2
@export var right_bubble_region: Rect2

# Hubungkan node-node dari scene ke script
# Pastikan nama node di Scene Tree SAMA PERSIS dengan yang ada setelah tanda $
@onready var background = $Background
@onready var speaker_name_label = $SpeakerName
@onready var dialogue_text_label = $DialogueText
@onready var choices_container = $ChoicesContainer

# Fungsi untuk menampilkan dialog
# -- PERBAIKAN: Mengganti nama parameter 'position' jadi 'tata_letak' --
# -- agar tidak bentrok dengan properti bawaan Godot --
func show_dialogue(speaker, text, tata_letak):
	self.show() # Tampilkan seluruh box
	speaker_name_label.text = speaker
	dialogue_text_label.text = text
	_clear_choices() # Bersihkan pilihan sebelumnya

	# Atur bubble dan posisi box berdasarkan tata letak
	if tata_letak == "left":
		# Gunakan bubble kiri
		background.region_rect = left_bubble_region
		self.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
		
	elif tata_letak == "right":
		# Gunakan bubble kanan
		background.region_rect = right_bubble_region
		self.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
		
	else: # "center" atau default
		background.region_rect = left_bubble_region
		self.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)

# Fungsi untuk menampilkan pilihan
func show_choices(choices_array):
	if choices_array.is_empty():
		return
	
	# ... (Logika membuat tombol pilihan, sama seperti sebelumnya)
	for choice in choices_array:
		var btn = Button.new()
		btn.text = choice["text"]
		btn.connect("pressed", func(): _on_choice_button_pressed(choice["id"]))
		choices_container.add_child(btn)

# Fungsi internal saat tombol pilihan ditekan
func _on_choice_button_pressed(choice_id):
	_clear_choices()
	self.hide()
	emit_signal("choice_made", choice_id)

# Fungsi untuk membersihkan tombol pilihan
func _clear_choices():
	for btn in choices_container.get_children():
		btn.queue_free()
		
# Fungsi untuk cek apakah kita sedang menampilkan pilihan
func is_showing_choices():
	return choices_container.get_child_count() > 0

# Sembunyikan box saat game baru dimulai
func _ready():
	self.hide()
