# Champter

## Sons

* musique d'ambiance
* bruitage explosion (peut-être plusieurs en fonction de l'explosion)
* bruitage ramassage de champignons
* bruitage fin de partie (plus de vie - game over)
* bruitage tableau fini (tous les champignons ont été ramassés)

## Graphismes

### éléments neutres

* hélicoptère du joueur vers la gauche => animation vol normal + explosion
* hélicoptère du joueur vers la droite => animation vol normal + explosion
* bombes pour le joueur (indicatif) => animation explosion
* éléments de décor (pierres, verdure, ...) => animation explosion

### éléments positifs

* champignons
* bonus score
* bonus temps
* bonus bombe
* bonus vie

### éléments nocifs

* araignées => animation montée/descente + explosion
* éléments de décor explosifs => animation explosion
* hélicoptères ennemis vers la gauche => animation vol normal + explosion
* hélicoptères ennemis vers la droite => animation vol normal + explosion

* pièges invisibles => animation de gobage du joueur

* tirs de laser
* fil de l'araignée

## TODO list

* modifier les références à "colblor" dans les fichiers de traduction

* ajouter liens de téléchargement sur README

* sortir la TODO list du fichier README

## Jeu vidéo Champter

https://champter.gamolf.fr

https://gamolf.itch.io/champter

### TODO list

* trouver les bruitages et la musique d'ambiance
* écran d'options / réglages (gestion des niveaux sonores et autres éléments)

* module de téléchargement d'un niveau de jeu
* module de stockage d'un niveau de jeu
* module de gestion de l'API
* écran de crédits / remerciements / licences
* écran tableau des scores
* gérer une pause
* gérer l'enregistrement de la partie en cours
* gérer le chargement d'une partie en cours
* traduction des textes
* parcourir la liste des images des sprites pour retailler la partie sélectionnée/utilisée de chaque image

* gérer les chauves souris

* sur menu d'accueil, ajouter bouton "reprendre" pour relancer la dernière partie mise en pause (s'il y en a une)

* gérer un joystick virtuel pour écrans smartphones / tablettes

* changer la couleur du fil de l'araignée en prenant une couleur provenant d'elle-même

* afficher chronomètre sur écran de jeu 

* modifier zone de collision sur joueur (ellipse plutôt que rectangle)

* (si nécessaire) optimiser la boucle de jeu (timer dans design) avec threads plutôt que séquentiel dans le traitement des sprites

* (si nécessaire) optimiser la boucle de jeu (timer dans design) avec begin/end update éventuellement (à tester)

* dans la zone de menus de l'écran d'accueil, ajouter un ascenseur si on déborde de la hauteur de l'écran, ou retailler les options de menu

* bogue : violations d'accès à corriger une fois les parties terminées et relancées

* bogue : collisions sur tir lors d'un déplacement du joueur, ne pas le faire sur le déplacement mais une fois positionné (ou tester si le laser est dans un mur ou réellement accessible)

* bogue : le niveau apparaît en bas à gauche au lieu d'être à sa place lorsqu'on est dans une partie (gridpanellayout, c'est louche)

* gérer le bonus score (apparition aléatoire ou en fonction du score)
* gérer le bonus temps (apparition aléatoire ou en fonction du score)
* gérer le bonus bombe (apparition aléatoire ou en fonction du score)
* gérer le bonus vie (apparition aléatoire ou en fonction du score)

* faire version tablette des commandes de direction et tir du joueur

* importer icones du jeu dans le projet

## Editeur de niveaux Champter

Editeur de niveaux pour le jeu permettant de modifier ou créer les tableaux officiels (verrouillés par mot de passe) et des tableaux personnels (pour les joueurs).

### TODO list

* module de téléchargement d'un niveau de jeu
* module de stockage d'un niveau de jeu
* module de gestion de l'API
* écran d'accueil
* écran de conception d'un niveau
* traduction des textes
* gérer trois niveau de tableaux de jeu : standard, joueur, extension (potentiellement payante)

* créer icone pour l'éditeur de niveau
* importer icone de l'éditeur de niveau dans le projet

## Serveur de stockage des niveaux du jeu

Module de stockage des niveaux de jeu avec possibilité d'en ajouter depuis l'éditeur de niveau et de les envoyer aux jeux sur demande.

https://champter.gamolf.fr/GameLevels

### TODO list

* API de gestion de la liste des niveaux
* API d'ajout d'un niveau
* API de modification d'un niveau
* API de suppression d'un niveau
* API de téléchargement de la liste des niveaux jouables
* API de téléchargement d'un niveau de jeu
