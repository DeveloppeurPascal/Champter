(* C2PP
  ***************************************************************************

  Champter

  Copyright 2021-2025 Patrick PREMARTIN under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://champter.gamolf.fr/

  Project site :
  https://github.com/DeveloppeurPascal/Champter

  ***************************************************************************
  File last update : 2025-05-25T09:31:36.614+02:00
  Signature : 2dfe8d02346703ae312ebad2a7f0dc8dd97d245e
  ***************************************************************************
*)

unit cDessinNiveau;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  fAncetreCadreTraduit, Champter.Types, FMX.Layouts, Champter.Consts,
  FMX.Objects, uSpritePiege, uSpriteTir, System.Generics.Collections, uSprite,
  FMX.Effects;

type
  TzoneDessinNiveau = class(T_AncetreCadreTraduit)
    zoneDAffichage: TScaledLayout;
    background: TRectangle;
    BoucleDeJeu: TTimer;
    GridPanelLayout1: TGridPanelLayout;
    txtScore: TText;
    txtNbVies: TText;
    txtNbBombes: TText;
    txtLevel: TText;
    txtChrono: TText;
    GlowEffect1: TGlowEffect;
    procedure BoucleDeJeuTimer(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    ListeSpritesAAnimer: TSpriteList;
    ListeSpritesInanimes: TSpriteList;
    procedure InitialiseEcran;
    procedure AfficheNiveau(ANiveau: TNiveau);
    procedure AjouteAraignee(x, y: single);
    procedure AjouteChampignon(x, y: single);
    procedure AjouteFleur(x, y: single);
    procedure AjouteMur(x, y: single);
    procedure AjouteJoueur(x, y: single);
    procedure AjouteEnnemi(x, y: single);
    procedure AjoutePiege(x, y: single; var CurrentPiege: TSpritePiege);
    procedure AjouteTir(x, y: single; var CurrentTir: TSpriteTir);
    procedure AjouteBonusScore(x, y: single);
    procedure AjouteBonusTemps(x, y: single);
    procedure AjouteBonusBombe(x, y: single);
    procedure AjouteBonusVie(x, y: single);
    procedure AdapterTailleZoneDeJeu;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure setScore(AScore: cardinal);
    procedure setNbVies(ANbVies: cardinal);
    procedure setNbBombes(ANbBombes: cardinal);
    procedure setLevel(ALevel: cardinal);
  end;

var
  zoneDessinNiveau: TzoneDessinNiveau;

implementation

{$R *.fmx}

uses uSpriteChampignon, uSpriteMur, uSpriteFleur, uSpriteAraignee,
  uSpriteJoueur, uSpriteBonus, USpriteEnnemi, uPartieEnCours, uDMTraductions,
  fMain;

{ TzoneDessinNiveau }

procedure TzoneDessinNiveau.AfficheNiveau(ANiveau: TNiveau);
var
  Colonne: tcolonne;
  CurCase: tcase;
  x, y: single;
  CurrentTir: TSpriteTir;
  CurrentPiege: TSpritePiege;
  HasCurrentEnnemi: boolean;
  HasCurrentJoueur: boolean;
begin
  CurrentTir := nil;
  CurrentPiege := nil;
  HasCurrentEnnemi := false;
  HasCurrentJoueur := false;

  // effacer les éléments actuels
  InitialiseEcran;

  // changer la taille de la zone en fonction de la taille du niveau passé
  zoneDAffichage.OriginalWidth := ANiveau.NbCol * cNbPixelsParCase;
  zoneDAffichage.Originalheight := ANiveau.Nblig * cNbPixelsParCase;

  // traitement de l'affichage du niveau
  y := 0;
  if (ANiveau.Grille.count > 0) then
    for Colonne in ANiveau.Grille do
    begin
      x := 0;
      if (Colonne.count > 0) then
        for CurCase in Colonne do
        begin
          if (CurCase and cHasAraignee > 0) then
            AjouteAraignee(x, y);
          if (CurCase and cHasChampignon > 0) then
            AjouteChampignon(x, y);
          if (CurCase and chasfleur > 0) then
            AjouteFleur(x, y);
          if (CurCase and cHasMur > 0) then
            AjouteMur(x, y);
          if (CurCase and cHasJoueur > 0) then
          begin
            if not HasCurrentJoueur then
            begin
              HasCurrentJoueur := true;
              AjouteJoueur(x, y);
            end;
          end
          else
            HasCurrentJoueur := false;
          if (CurCase and cHasEnnemi > 0) then
          begin
            if not HasCurrentEnnemi then
            begin
              HasCurrentEnnemi := true;
              AjouteEnnemi(x, y);
            end;
          end
          else
            HasCurrentEnnemi := false;
          if (CurCase and cHasPiege > 0) then
            AjoutePiege(x, y, CurrentPiege)
          else
            CurrentPiege := nil;
          if (CurCase and cHasTir > 0) then
            AjouteTir(x, y, CurrentTir)
          else
            CurrentTir := nil;
          x := x + cNbPixelsParCase;
        end;
      y := y + cNbPixelsParCase;
    end;

  // retaille l'image
  AdapterTailleZoneDeJeu;

  // On lance les animations de l'écran
  BoucleDeJeu.Enabled := true;
end;

procedure TzoneDessinNiveau.AjouteAraignee(x, y: single);
var
  spr: TSpriteAraignee;
begin
  spr := TSpriteAraignee.AjouteAraignee(zoneDAffichage, x, y);
  if spr.EnMouvement = TSpriteEnMouvement.oui then
    ListeSpritesAAnimer.Add(spr)
  else
    ListeSpritesInanimes.Add(spr);
end;

procedure TzoneDessinNiveau.AjouteBonusScore(x, y: single);
var
  spr: TSpriteBonus;
begin
  spr := TSpriteBonus.AjouteBonus(zoneDAffichage, x, y, tbonustype.Score);
  if spr.EnMouvement = TSpriteEnMouvement.oui then
    ListeSpritesAAnimer.Add(spr)
  else
    ListeSpritesInanimes.Add(spr);
end;

procedure TzoneDessinNiveau.AjouteBonusBombe(x, y: single);
var
  spr: TSpriteBonus;
begin
  spr := TSpriteBonus.AjouteBonus(zoneDAffichage, x, y, tbonustype.bombe);
  if spr.EnMouvement = TSpriteEnMouvement.oui then
    ListeSpritesAAnimer.Add(spr)
  else
    ListeSpritesInanimes.Add(spr);
end;

procedure TzoneDessinNiveau.AjouteBonusTemps(x, y: single);
var
  spr: TSpriteBonus;
begin
  spr := TSpriteBonus.AjouteBonus(zoneDAffichage, x, y, tbonustype.temps);
  if spr.EnMouvement = TSpriteEnMouvement.oui then
    ListeSpritesAAnimer.Add(spr)
  else
    ListeSpritesInanimes.Add(spr);
end;

procedure TzoneDessinNiveau.AjouteBonusVie(x, y: single);
var
  spr: TSpriteBonus;
begin
  spr := TSpriteBonus.AjouteBonus(zoneDAffichage, x, y, tbonustype.vie);
  if spr.EnMouvement = TSpriteEnMouvement.oui then
    ListeSpritesAAnimer.Add(spr)
  else
    ListeSpritesInanimes.Add(spr);
end;

procedure TzoneDessinNiveau.AjouteChampignon(x, y: single);
var
  spr: TSpriteChampignon;
begin
  spr := TSpriteChampignon.AjouteChampignon(zoneDAffichage, x, y);
  if spr.EnMouvement = TSpriteEnMouvement.oui then
    ListeSpritesAAnimer.Add(spr)
  else
    ListeSpritesInanimes.Add(spr);
end;

procedure TzoneDessinNiveau.AjouteEnnemi(x, y: single);
var
  spr: TSpriteEnnemi;
begin
  spr := TSpriteEnnemi.AjouteEnnemi(zoneDAffichage, x, y);
  if spr.EnMouvement = TSpriteEnMouvement.oui then
    ListeSpritesAAnimer.Add(spr)
  else
    ListeSpritesInanimes.Add(spr);
end;

procedure TzoneDessinNiveau.AjouteFleur(x, y: single);
var
  spr: TSpriteFleur;
begin
  spr := TSpriteFleur.AjouteFleur(zoneDAffichage, x, y);
  if spr.EnMouvement = TSpriteEnMouvement.oui then
    ListeSpritesAAnimer.Add(spr)
  else
    ListeSpritesInanimes.Add(spr);
end;

procedure TzoneDessinNiveau.AjouteJoueur(x, y: single);
var
  spr: tspritejoueur;
begin
  spr := tspritejoueur.AjouteJoueur(zoneDAffichage, x, y);
  if spr.EnMouvement = TSpriteEnMouvement.oui then
    ListeSpritesAAnimer.Add(spr)
  else
    ListeSpritesInanimes.Add(spr);
end;

procedure TzoneDessinNiveau.AjouteMur(x, y: single);
var
  spr: tspritemur;
begin
  spr := tspritemur.AjouteMur(zoneDAffichage, x, y);
  if spr.EnMouvement = TSpriteEnMouvement.oui then
    ListeSpritesAAnimer.Add(spr)
  else
    ListeSpritesInanimes.Add(spr);
end;

procedure TzoneDessinNiveau.AjoutePiege(x, y: single;
  var CurrentPiege: TSpritePiege);
begin
  if (CurrentPiege <> nil) then
    CurrentPiege.obj.Width := CurrentPiege.obj.Width + cNbPixelsParCase
  else
  begin
    CurrentPiege := TSpritePiege.AjoutePiege(zoneDAffichage, x, y);
    if CurrentPiege.EnMouvement = TSpriteEnMouvement.oui then
      ListeSpritesAAnimer.Add(CurrentPiege)
    else
      ListeSpritesInanimes.Add(CurrentPiege);
  end;
end;

procedure TzoneDessinNiveau.AjouteTir(x, y: single; var CurrentTir: TSpriteTir);
begin
  if (CurrentTir <> nil) then
    CurrentTir.obj.Width := CurrentTir.obj.Width + cNbPixelsParCase
  else
  begin
    CurrentTir := TSpriteTir.AjouteTir(zoneDAffichage, x, y);
    if CurrentTir.EnMouvement = TSpriteEnMouvement.oui then
      ListeSpritesAAnimer.Add(CurrentTir)
    else
      ListeSpritesInanimes.Add(CurrentTir);
  end;
end;

procedure TzoneDessinNiveau.BoucleDeJeuTimer(Sender: TObject);
var
  sprite: TSprite;
begin
  if partieencours then
  begin
    if (nbvies < 1) then // fin de partie
    begin
      PartieFinie;
      frmmain.afficheecran(tecrans.PartiePerdue);
      exit;
    end;

    if (NbChampignonsARamasser < 1) then // fin de niveau
    begin
      NiveauFini;
      frmmain.afficheecran(tecrans.NiveauSuivant);
      exit;
    end;

    // TODO : de temps en temps, ajouter un bonus à l'écran sur une zone vide
  end;

  if (ListeSpritesAAnimer.count > 0) then
    for sprite in ListeSpritesAAnimer do
      if (sprite.EnMouvement = TSpriteEnMouvement.oui) then
        sprite.DoMouvement;
end;

constructor TzoneDessinNiveau.Create(AOwner: TComponent);
begin
  inherited;
  ZoneAffichageNiveauDuJeu := self;
  BoucleDeJeu.Enabled := false;
  ListeSpritesAAnimer := TSpriteList.Create;
  ListeSpritesInanimes := TSpriteList.Create;
end;

destructor TzoneDessinNiveau.Destroy;
begin
  BoucleDeJeu.Enabled := false;
  ListeSpritesAAnimer.free;
  ListeSpritesInanimes.free;
  inherited;
end;

procedure TzoneDessinNiveau.InitialiseEcran;
begin
  BoucleDeJeu.Enabled := false;
  while zoneDAffichage.ChildrenCount > 0 do
    zoneDAffichage.children[0].free;
  ListeSpritesAAnimer.Clear;
  ListeSpritesInanimes.Clear;
  setScore(Score);
  setNbVies(nbvies);
  setNbBombes(NbBombes);
  setLevel(niveaudujeu);
  // TODO : ajouter setChrono / gérer le chrono éventuellement
  txtChrono.Visible := false;
end;

procedure TzoneDessinNiveau.setLevel(ALevel: cardinal);
begin
  if not partieencours then
  begin
    txtLevel.Visible := false;
    niveaudujeu := ALevel;
    exit;
  end
  else
    txtLevel.Visible := true;

  niveaudujeu := ALevel;
  txtLevel.Text := _('level', 'Niveau : ') + (niveaudujeu + 1).ToString;
end;

procedure TzoneDessinNiveau.setNbBombes(ANbBombes: cardinal);
begin
  if not partieencours then
  begin
    txtNbBombes.Visible := false;
    NbBombes := ANbBombes;
    exit;
  end
  else
    txtNbBombes.Visible := true;

  NbBombes := ANbBombes;
  txtNbBombes.Text := _('nbbombes', 'Bombes : ') + NbBombes.ToString;
end;

procedure TzoneDessinNiveau.setNbVies(ANbVies: cardinal);
begin
  if not partieencours then
  begin
    txtNbVies.Visible := false;
    nbvies := ANbVies;
    exit;
  end
  else
    txtNbVies.Visible := true;

  if (nbvies > ANbVies) then
  begin
    // TODO : faire animation perte d'une vie
  end;
  nbvies := ANbVies;
  txtNbVies.Text := _('nbvies', 'Vies : ') + nbvies.ToString;
end;

procedure TzoneDessinNiveau.setScore(AScore: cardinal);
begin
  if not partieencours then
  begin
    txtScore.Visible := false;
    Score := AScore;
    exit;
  end
  else
    txtScore.Visible := true;

  Score := AScore;
  txtScore.Text := _('score', 'Score : ') + Score.ToString;
end;

procedure TzoneDessinNiveau.AdapterTailleZoneDeJeu;
var
  Largeur, Hauteur: single;
  LargeurMax, HauteurMax: single;
  W, H: single;
begin
  if (parent is tcontrol) then
  begin
    LargeurMax := (parent as tcontrol).Width;
    HauteurMax := (parent as tcontrol).height;
  end
  else if (parent is tform) then
  begin
    LargeurMax := (parent as tform).clientWidth;
    HauteurMax := (parent as tform).clientheight;
  end
  else
    raise exception.Create('resize failed');

  LargeurMax := LargeurMax;
  HauteurMax := HauteurMax;

  // Taille idéale de la zone de jeu
  // (en fonction de la taille d'origine de l'image à y afficher)
  Largeur := zoneDAffichage.OriginalWidth;
  Hauteur := zoneDAffichage.Originalheight;

  // Calcul de la nouvelle taille
  W := LargeurMax;
  H := W * Hauteur / Largeur;
  if (H > HauteurMax) then
  begin
    H := HauteurMax;
    W := H * Largeur / Hauteur;
  end;

  // Changement de la taille
  self.beginupdate;
  self.Width := W;
  self.height := H;
  self.endupdate;
end;

end.
