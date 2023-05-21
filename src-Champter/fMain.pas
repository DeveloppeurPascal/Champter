unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  fAncetreFicheTraduite, FMX.Controls.Presentation, FMX.Memo.Types,
  FMX.ScrollBox, fAncetreCadreTraduit, cDessinNiveau, Champter.Types,
  FMX.Effects, FMX.Objects, FMX.Layouts;

type
{$SCOPEDENUMS on}
  TEcrans = (Aucun, Accueil, Jeu, Scores, Credits, Options, Quitter,
    PartiePerdue, NiveauSuivant, FinDePartie);

  TfrmMain = class(T_AncetreFicheTraduite)
    zoneDessinNiveau1: TzoneDessinNiveau;
    Button1: TButton;
    ZoneMenuAccueil: TLayout;
    btnMenuOptions: TRectangle;
    txtMenuOptions: TText;
    ShadowEffect3: TShadowEffect;
    btnMenuCredits: TRectangle;
    txtMenuCredits: TText;
    ShadowEffect4: TShadowEffect;
    btnMenuQuitter: TRectangle;
    txtMenuQuitter: TText;
    ShadowEffect5: TShadowEffect;
    btnMenuScores: TRectangle;
    txtMenuScores: TText;
    ShadowEffect2: TShadowEffect;
    btnMenuJouer: TRectangle;
    txtMenuJouer: TText;
    ShadowEffect1: TShadowEffect;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnMenuCreditsClick(Sender: TObject);
    procedure btnMenuJouerClick(Sender: TObject);
    procedure btnMenuOptionsClick(Sender: TObject);
    procedure btnMenuQuitterClick(Sender: TObject);
    procedure btnMenuScoresClick(Sender: TObject);
    procedure btnMenuScoresMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btnMenuQuitterMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btnMenuCreditsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btnMenuJouerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btnMenuOptionsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    { Déclarations privées }
    GroupeDePresentation, GroupeDeJeu: TGroupeDeNiveaux;
    EcranActuel: TEcrans;
{$IFDEF DEBUG}
    numtab, numgroupe: integer;
{$ENDIF}
    function getDataDiskPath(FileName: string): string;
  public
    procedure TraduireTextes; override;
    { Déclarations publiques }
    procedure AfficheEcran(AEcran: TEcrans);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  System.ioutils, uDMTraductions, uPartieEnCours, uSprite, JoystickManager,
  uSoundsAndMusics;

{ TfrmMain }

procedure TfrmMain.AfficheEcran(AEcran: TEcrans);
begin
  EcranActuel := AEcran;
  case EcranActuel of
    TEcrans.Accueil:
      begin
        zoneDessinNiveau1.AfficheNiveau(GroupeDePresentation.ListeDeNiveaux[0]);
{$IF Defined(IOS) or Defined(ANDROID)}
        btnMenuQuitter.Visible := false;
{$ENDIF}
        btnMenuScores.Visible := false;
        btnMenuCredits.Visible := false;
        btnMenuOptions.Visible := false;
      end;
    TEcrans.Jeu:
      begin
        NouvellePartie;
        NouveauNiveau(0);
        zoneDessinNiveau1.AfficheNiveau(GroupeDeJeu.ListeDeNiveaux
          [NiveauDuJeu]);
      end;
    TEcrans.NiveauSuivant:
      begin
        if (NiveauDuJeu + 1 < GroupeDeJeu.ListeDeNiveaux.Count) then
        begin
          // Passage au niveau suivant dans cette extension
          PlaySound(TGameSounds.WinLevel);
          NouveauNiveau(NiveauDuJeu + 1);
          zoneDessinNiveau1.AfficheNiveau
            (GroupeDeJeu.ListeDeNiveaux[NiveauDuJeu]);
        end
        else
        begin
          // Plus de niveaux disponibles dans cette extension
          PartieFinie;
          AfficheEcran(TEcrans.FinDePartie);
        end;
      end;
    TEcrans.Scores:
      begin
        // TODO : à compléter
      end;
    TEcrans.Credits:
      begin
        // TODO : à compléter
      end;
    TEcrans.Options:
      begin
        // TODO : à compléter
      end;
    TEcrans.Quitter:
      begin
        close;
      end;
    TEcrans.PartiePerdue:
      begin
        PlaySound(TGameSounds.GameOver);
        // TODO : à compléter !!! non compatibles mobiles !!!
        zoneDessinNiveau1.AfficheNiveau(GroupeDePresentation.ListeDeNiveaux[3]);
        if (score > 1) then
          ShowMessage('Partie perdue avec un score de ' + score.ToString +
            ' points.')
        else
          ShowMessage('Mort avant de manger de bons champignons ! LOL');
        AfficheEcran(TEcrans.Accueil);
      end;
    TEcrans.FinDePartie:
      begin
        // TODO : à compléter !!! non compatibles mobiles !!!
        PlaySound(TGameSounds.WinGame);
        zoneDessinNiveau1.AfficheNiveau(GroupeDePresentation.ListeDeNiveaux[3]);
        ShowMessage('Bravo, vous avez fini le jeu avec un score de ' +
          score.ToString + ' points.');
        AfficheEcran(TEcrans.Accueil);
        // TODO : proposer téléchargement d'une autre extension si il y en a de disponibles
      end;
  else
    raise exception.create('Type d''écran non géré.');
  end;
  ZoneMenuAccueil.Visible := (EcranActuel = TEcrans.Accueil);
end;

procedure TfrmMain.btnMenuCreditsClick(Sender: TObject);
begin
  AfficheEcran(TEcrans.Credits);
end;

procedure TfrmMain.btnMenuCreditsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  PlaySound(TGameSounds.UIButtonClick);
end;

procedure TfrmMain.btnMenuJouerClick(Sender: TObject);
begin
  AfficheEcran(TEcrans.Jeu);
end;

procedure TfrmMain.btnMenuJouerMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  PlaySound(TGameSounds.UIButtonClick);
end;

procedure TfrmMain.btnMenuOptionsClick(Sender: TObject);
begin
  AfficheEcran(TEcrans.Options);
end;

procedure TfrmMain.btnMenuOptionsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  PlaySound(TGameSounds.UIButtonClick);
end;

procedure TfrmMain.btnMenuQuitterClick(Sender: TObject);
begin
  AfficheEcran(TEcrans.Quitter);
end;

procedure TfrmMain.btnMenuQuitterMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  PlaySound(TGameSounds.UIButtonClick);
end;

procedure TfrmMain.btnMenuScoresClick(Sender: TObject);
begin
  AfficheEcran(TEcrans.Scores);
end;

procedure TfrmMain.btnMenuScoresMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  PlaySound(TGameSounds.UIButtonClick);
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
{$IFDEF DEBUG}
  if (numtab < GroupeDePresentation.ListeDeNiveaux.Count - 1) then
    inc(numtab)
  else if (numgroupe < 5) then
  begin
    numtab := 0;
    inc(numgroupe);
    case numgroupe of
      1:
        GroupeDeJeu.LoadFromFile
          ('C:\Users\olfso\Documents\Embarcadero\Studio\Projets\GAMECPTR\COPTER01.DAT');
      2:
        GroupeDeJeu.LoadFromFile
          ('C:\Users\olfso\Documents\Embarcadero\Studio\Projets\GAMECPTR\COPTER02.DAT');
      3:
        GroupeDeJeu.LoadFromFile
          ('C:\Users\olfso\Documents\Embarcadero\Studio\Projets\GAMECPTR\COPTER03.DAT');
    else
      GroupeDeJeu.LoadFromFile
        ('C:\Users\olfso\Documents\Embarcadero\Studio\Projets\GAMECPTR\COPTER00.DAT');
      numgroupe := 0;
      ShowMessage('fini');
      exit;
    end;
  end;
  zoneDessinNiveau1.AfficheNiveau(GroupeDeJeu.ListeDeNiveaux[numtab]);
{$ENDIF}
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  inherited;
{$IFDEF DEBUG}
  numtab := 0;
  numgroupe := 0;
{$ELSE}
  Button1.Visible := false;
{$ENDIF}
  GroupeDePresentation := TGroupeDeNiveaux.create;
  GroupeDePresentation.LoadFromFile(getDataDiskPath('COPTER.PRS'));
  GroupeDeJeu := TGroupeDeNiveaux.create;
  GroupeDeJeu.LoadFromFile(getDataDiskPath('COPTER00.DAT'));
  EcranActuel := TEcrans.Aucun;
  tthread.forcequeue(nil,
    procedure
    begin
      StartJoystick;
      AfficheEcran(TEcrans.Accueil);
      PlayMusic(TGameMusics.Song_Exploration_02_Loop);
      // TODO : jouer la musique configurée (si plusieurs choix dans les réglages) plutôt que la musique par défaut
    end);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  inherited;
  GroupeDeJeu.free;
  GroupeDePresentation.free;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkEscape) or (Key = vkHardwareBack) then
  begin
    if EcranActuel = TEcrans.Accueil then
      // Si écran d'accueil, sortir du programme
      close
    else if EcranActuel = TEcrans.Jeu then
    begin
      // Si écran de jeu, faire une pause et revenir à l'accueil
      // TODO : mettre le jeu en pause (archiver l'état de la partie en cours)
      PartieFinie;
      AfficheEcran(TEcrans.Accueil);
    end
    else
      // Si autre écran, revenir à l'écran précédent ou l'accueil
      AfficheEcran(TEcrans.Accueil);
    Key := 0;
    KeyChar := #0;
  end
  else if (Key = vkReturn) then
    case EcranActuel of
      TEcrans.Accueil:
        btnMenuJouerClick(Sender);
      TEcrans.Jeu:
        ;
      TEcrans.Scores, TEcrans.Credits, TEcrans.Options, TEcrans.PartiePerdue,
        TEcrans.FinDePartie:
        // TODO : simuler click sur bouton RETOUR ou équivalent par défaut
        ;
    else
      // TODO : gérer bouton RETURN sur écrans non pris en charge
    end;
  if assigned(SpriteDuJoueur) and partieencours then
  begin
    if Key = vkUp then
    begin
      SpriteDuJoueur.vavers(TSpriteSensDeplacement.VersLeHaut);
      Key := 0;
      KeyChar := #0;
    end;
    if Key = vkLeft then
    begin
      SpriteDuJoueur.vavers(TSpriteSensDeplacement.VersLaGauche);
      Key := 0;
      KeyChar := #0;
    end;
    if Key = vkright then
    begin
      SpriteDuJoueur.vavers(TSpriteSensDeplacement.VersLadroite);
      Key := 0;
      KeyChar := #0;
    end;
    if Key = vkDown then
    begin
      SpriteDuJoueur.vavers(TSpriteSensDeplacement.VersLebas);
      Key := 0;
      KeyChar := #0;
    end;
    if (Key = vkSpace) or (KeyChar = ' ') then
    begin
      SpriteDuJoueur.LanceExplosif;
      Key := 0;
      KeyChar := #0;
    end;
  end;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  zoneDessinNiveau1.AdapterTailleZoneDeJeu;
end;

function TfrmMain.getDataDiskPath(FileName: string): string;
begin
{$IF Defined(DEBUG) and Defined(MSWINDOWS)}
  result := '..\..\..\levels\' + FileName;
{$ELSE}
{$IF Defined(ANDROID)}
  result := tpath.combine(tpath.getdocumentPath, FileName);
{$ELSE}
  result := tpath.combine(tpath.GetDirectoryName(paramstr(0)), FileName);
{$ENDIF}
{$ENDIF}
end;

procedure TfrmMain.TraduireTextes;
begin
  inherited;
  caption := _('TitreDuJeu', 'Champter'); // TODO : traduire le texte
  txtMenuOptions.text := _('mnuOptions', 'Options'); // TODO : traduire le texte
  txtMenuCredits.text := _('mnuCredits', 'Credits'); // TODO : traduire le texte
  txtMenuQuitter.text := _('mnuQuitter', 'Quitter'); // TODO : traduire le texte
  txtMenuScores.text := _('mnuScores', 'Scores'); // TODO : traduire le texte
  txtMenuJouer.text := _('mnuJouer', 'Jouer'); // TODO : traduire le texte
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
