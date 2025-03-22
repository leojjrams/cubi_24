extends Node

var current_hour = -1  # Stocke l'heure actuelle
var timer: Timer  # Stocke une référence au Timer

func _ready():
	print("Démarrage du script")
	_check_and_load_game()  # Charger le mini-jeu au démarrage
	_start_timer()  # Lancer le timer pour surveiller l'heure

func _start_timer():
	print("Création du timer...")
	timer = Timer.new()
	timer.wait_time = 30  # Vérifie toutes les 10 secondes
	timer.one_shot = false  # Assure que le timer se répète
	add_child(timer)  # Ajoute le timer à la scène
	print("Timer ajouté à la scène")

	# Vérifier si la connexion est bien faite
	var connected = timer.timeout.connect(_check_and_load_game)
	if connected == OK:
		print("Connexion du timer réussie")
	else:
		print("Erreur lors de la connexion du timer")

	timer.start()  # Démarre le timer
	print("Timer démarré, vérification toutes les 10 secondes")

func _check_and_load_game():
	print("Vérification de l'heure...")
	var hour = Time.get_time_dict_from_system().hour
	print("Heure actuelle :", hour)

	if hour != current_hour:  # Si l'heure a changé, on charge un nouveau mini-jeu
		print("Nouvelle heure détectée ! Changement de scène en cours...")
		current_hour = hour
		var scene_path = "res://mini_jeux/mini_jeu_" + str(hour % 24) + ".tscn"
		print("Tentative de chargement :", scene_path)

		if ResourceLoader.exists(scene_path):
			print("Scène trouvée ! Changement en cours...")
			get_tree().call_deferred("change_scene_to_file", scene_path)
		else:
			print("Erreur : Mini-jeu non trouvé ->", scene_path)
