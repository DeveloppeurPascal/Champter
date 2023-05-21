unit uPartieEnCours;

interface

uses
  uSpriteJoueur, cDessinNiveau;

var
  /// <summary>
  /// Lien vers le vaisseu du joueur actuellement à l'écran
  /// </summary>
  SpriteDuJoueur: TSpriteJoueur;
  /// <summary>
  /// Lien vers la zone d'affichage du niveau en cours
  /// </summary>
  ZoneAffichageNiveauDuJeu: TzoneDessinNiveau;
  /// <summary>
  /// Score actuel du joueur dans la partie en cours
  /// </summary>
  Score: cardinal;
  /// <summary>
  /// Nombre de vies restantes du joueur dans la partie en cours
  /// </summary>
  NbVies: cardinal;
  /// <summary>
  /// Nombre de bombes restantes du joueur dans la partie en cours
  /// </summary>
  NbBombes: cardinal;
  /// <summary>
  /// Temps restant pour finir le niveau actuel
  /// </summary>
  TempsRestant: cardinal; // TODO : gérer le chrono
  /// <summary>
  /// Info permettant de savoir si une partie est en cours ou si on est sur un écran d'interface/info du jeu
  /// </summary>
  PartieEnCours: boolean;
  /// <summary>
  /// Numéro de l'extension sur laquelle est actuellement le joueur
  /// </summary>
  NumeroExtension: cardinal;
  /// <summary>
  /// Niveau actuel du joueur dans la partie en cours
  /// </summary>
  NiveauDuJeu: cardinal;
  /// <summary>
  /// Nombre de champignons présents à l'écran
  /// </summary>
  NbChampignonsARamasser: cardinal;

procedure NouvellePartie;
procedure NouveauNiveau(ANiveauDuJeu: cardinal);
procedure NiveauFini;
procedure PartieFinie;

implementation

uses Champter.Consts;

procedure NouvellePartie;
begin
  PartieEnCours := true;
  ZoneAffichageNiveauDuJeu.setScore(0);
  ZoneAffichageNiveauDuJeu.setNbVies(cInitNbVies);
end;

procedure NouveauNiveau(ANiveauDuJeu: cardinal);
begin
  ZoneAffichageNiveauDuJeu.setLevel(ANiveauDuJeu);
  ZoneAffichageNiveauDuJeu.setNbBombes(cInitNbBombes);
  // TempsRestant := cInitChrono;
  // TODO : gérer chrono
  NbChampignonsARamasser := 0;
end;

procedure NiveauFini;
begin
  ZoneAffichageNiveauDuJeu.setScore(Score + NbVies * cScoreViesRestantes);
  ZoneAffichageNiveauDuJeu.setScore(Score + NbBombes * cScoreBombesRestantes);
  ZoneAffichageNiveauDuJeu.setScore(Score + (NiveauDuJeu + 1) *
    cScoreBonusNiveauTermine);
  // TODO : gérer temps restant
  // ZoneAffichageNiveauDuJeu.setScore(score+TempsRestant*cScoreTempsRestant);
end;

procedure PartieFinie;
begin
  PartieEnCours := false;
end;

initialization

SpriteDuJoueur := nil;
ZoneAffichageNiveauDuJeu := nil;
PartieEnCours := false;
NumeroExtension := 0; // groupe de niveaux de base
NiveauDuJeu := 0;

end.
