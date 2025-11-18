# scripts/GlobalState.gd
extends Node

# Variabel ini akan bisa diakses dari mana saja
var current_chapter = "prologue"

# Fungsi praktis untuk pindah scene
func go_to_scene(scene_path):
    print("Pindah ke scene: ", scene_path)
    # get_tree().change_scene_to_file(scene_path)
    # Untuk latihan, kita beri komentar dulu agar tidak error
    # Hapus komentar di atas jika Anda sudah punya scene berikutnya

# Fungsi untuk me-reset scene ini (jika gagal)
func reload_current_scene():
    get_tree().reload_current_scene()