extends Panel

# --- KONFIGURASI ---
var percobaan_saat_ini = 0
var target_pity = 10 # Di percobaan ke-10 pasti berhasil

# --- MENGAMBIL NODE ANAK ---
# Kita pakai @onready supaya script tahu node mana yang mau diubah
@onready var label_angka = $LabelAngka
@onready var tombol_refresh = $TombolRefresh

func _ready():
	# 1. Menghubungkan Signal dari Dialogic (Supaya timeline bisa manggil)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	# 2. Menghubungkan Tombol (Supaya kalau diklik, dia jalanin fungsi)
	tombol_refresh.pressed.connect(_saat_tombol_ditekan)
	
	# Pastikan sembunyi pas game mulai
	visible = false

# --- FUNGSI UTAMA GAME ---
func _saat_tombol_ditekan():
	percobaan_saat_ini += 1
	var angka = 0
	
	# LOGIKA PITY SYSTEM (Sistem Kasihan)
	if percobaan_saat_ini >= target_pity:
		angka = 6 # Paksa jadi 6
		print("Pity System Aktif! Dikasih angka 6.")
	else:
		angka = randi_range(1, 6) # Acak angka 1 sampai 6
	
	# Update Tampilan
	label_angka.text = str(angka)
	
	# Cek apakah menang?
	if angka == 6:
		menang()
	else:
		print("Dapat " + str(angka) + ". Coba lagi.")

func menang():
	tombol_refresh.disabled = true
	tombol_refresh.text = "SURAT DITERIMA!"
	
	# Tunggu 1 detik biar pemain sempat lihat angka 6-nya
	await get_tree().create_timer(1.0).timeout
	
	# Sembunyikan kotak
	visible = false
	
	# Beritahu Dialogic untuk lanjut ngobrol
	Dialogic.paused = false
	Dialogic.handle_next_event()

# --- FUNGSI PEMICU DARI DIALOGIC ---
func _on_dialogic_signal(argument: String):
	if argument == "buka_email":
		mulai_game()

func mulai_game():
	print("Minigame Email Dimulai")
	visible = true # Munculkan kotak
	
	# Reset status
	percobaan_saat_ini = 0
	label_angka.text = "0"
	tombol_refresh.disabled = false
	tombol_refresh.text = "Refresh Inbox"
	
	# Pause Dialogic supaya teks percakapan berhenti dulu
	Dialogic.paused = true