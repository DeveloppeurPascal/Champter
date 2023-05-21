unit uPartieEnCours;

interface

uses
  uSpriteJoueur, cDessinNiveau;

var
  /// <summary>
  /// Lien vers le vaisseu du joueur actuellement � l'�cran
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
  TempsRestant: cardinal; // TODO : g�rer le chrono
  /// <summary>
  /// Info permettant de savoir si une partie est en cours ou si on est sur un �cran d'interface/info du jeu
  /// </summary>
  PartieEnCours: boolean;
  /// <summary>
  /// Num�ro de l'extension sur laquelle est actuellement le joueur
  /// </summary>
  NumeroExtension: cardinal;
  /// <summary>
  /// Niveau actuel du joueur dans la partie en cours
  /// </summary>
  NiveauDuJeu: cardinal;
  /// <summary>
  /// Nombre de champignons pr�sents � l'�cran
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
  // TODO : g�rer chrono
  NbChampignonsARamasser := 0;
end;

procedure NiveauFini;
begin
  ZoneAffichageNiveauDuJeu.setScore(Score + NbVies * cScoreViesRestantes);
  ZoneAffichageNiveauDuJeu.setScore(Score + NbBombes * cScoreBombesRestantes);
  ZoneAffichageNiveauDuJeu.setScore(Score + (NiveauDuJeu + 1) *
    cScoreBonusNiveauTermine);
  // TODO : g�rer temps restant
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
