# ui/DialogueBox.gd
extends Control

# Sinyal ini akan kita kirim ke scene Prolog saat pemain memilih
signal choice_made(choice_id)

# -- PERUBAHAN DIMULAI DI SINI --

# Variabel ini akan muncul di Inspector.
# Anda bisa atur koordinatnya secara visual di panel TextureRegion.
@export var left_bubble_region: Rect2
@export var right_bubble_region: Rect2

# Anda juga bisa menambahkan region untuk bubble "Narator" jika ada
# @export var narrator_bubble_region: Rect2

# -- SELESAI PERUBAHAN --

# Hubungkan node-node dari scene ke script
@onready var background = $Background
@onready var speaker_name_label = $SpeakerName
@onready var dialogue_text_label = $DialogueText
@onready var choices_container = $ChoicesContainer

# Fungsi untuk menampilkan dialog
# -- PERUBAHAN DIMULAI DI SINI --
# Kita tambahkan parameter 'position'
func show_dialogue(speaker, text, position):
    self.show() # Tampilkan seluruh box
    speaker_name_label.text = speaker
    dialogue_text_label.text = text
    _clear_choices() # Bersihkan pilihan sebelumnya

    # Atur bubble dan posisi box berdasarkan siapa yang bicara
    if position == "left":
        # Gunakan bubble kiri
        background.texture_region = left_bubble_region
        # Atur anchor agar box menempel di kiri
        # (Anda mungkin perlu menyesuaikan nilai ini)
        self.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
        
    elif position == "right":
        # Gunakan bubble kanan
        background.texture_region = right_bubble_region
        # Atur anchor agar box menempel di kanan
        # (Anda mungkin perlu menyesuaikan nilai ini)
        self.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
        
    else: # "center" atau "narrator"
        # Gunakan bubble kiri (atau narrator_bubble_region jika ada)
        background.texture_region = left_bubble_region
        # Atur anchor agar box di tengah bawah
        self.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)

# Fungsi untuk menampilkan pilihan
func show_choices(choices_array):
    if choices_array.is_empty():
        return

    # Buat tombol untuk setiap pilihan
    for choice in choices_array:
        var button = Button.new()
        button.text = choice.text
        choices_container.add_child(button)
        
        # Hubungkan sinyal 'pressed' dari tombol ke fungsi lokal
        # Kita kirim 'choice.id' agar tahu pilihan mana yang ditekan
        button.pressed.connect(_on_choice_button_pressed.bind(choice.id))

# Fungsi internal saat tombol pilihan ditekan
func _on_choice_button_pressed(choice_id):
    _clear_choices()
    self.hide() # Sembunyikan dialogue box setelah memilih
    
    # KIRIM SINYAL!
    # Memberi tahu scene Prolog bahwa pemain telah memilih
    emit_signal("choice_made", choice_id)

# Fungsi untuk membersihkan tombol pilihan
func _clear_choices():
    for btn in choices_container.get_children():
        btn.queue_free() # Hapus semua tombol
        
# Fungsi untuk cek apakah kita sedang menampilkan pilihan
func is_showing_choices():
    return choices_container.get_child_count() > 0

# Sembunyikan box saat game baru dimulai
func _ready():
    self.hide()