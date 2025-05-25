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
  File last update : 2025-05-25T09:31:36.634+02:00
  Signature : 240c1b0c0a740b4f223e272ae523566cf3c6d08e
  ***************************************************************************
*)

unit uSpriteJoueur;

interface

uses
  fmx.controls, uSprite, uSoundsAndMusics;

type
  TSpriteJoueur = class(tsprite)
  private
    OrigineX, OrigineY: single;
  public
    class function AjouteJoueur(AParent: TControl; AX, AY: single)
      : TSpriteJoueur;
    procedure DoMouvement; override;
    function HasCollision(AX: single; AY: single): Boolean; override;
    procedure DoExplose(SoundToPlay: tgamesounds); override;
    procedure VaVers(Direction: TSpriteSensDeplacement);
    procedure LanceExplosif;
  end;

implementation

uses
  fmx.layouts, system.classes, fmx.types, fmx.objects, fmx.graphics, uDMImages,
  system.types, Champter.Consts, uSpriteAraignee, USpriteEnnemi, uSpriteFleur,
  uSpritePiege, uSpriteTir, uSpriteChampignon, uSpriteBonus, uPartieEnCours,
  uSpriteMur;

{ TSpriteJoueur }

class function TSpriteJoueur.AjouteJoueur(AParent: TControl; AX, AY: single)
  : TSpriteJoueur;
var
  r: trectangle;
  taille: tsizef;
begin
  result := TSpriteJoueur.Create;
  result.x := AX;
  result.y := AY;
  result.OrigineX := AX;
  result.OrigineY := AY;
  r := trectangle.Create(AParent);
  r.parent := AParent;
  r.stroke.Kind := tbrushkind.none;
  r.fill.Kind := tbrushkind.bitmap;
  taille.width := 2 * cNbPixelsParCase;
  taille.height := cNbPixelsParCase;
  r.size.size := taille;
  r.fill.bitmap.WrapMode := TWrapMode.TileStretch;
  r.fill.bitmap.bitmap.Assign(dmimages.imgsprites.bitmap(taille, 0));
  result.obj := r;
  result.EnMouvement := TSpriteEnMouvement.oui;
  spritedujoueur := result;
end;

procedure TSpriteJoueur.DoExplose(SoundToPlay: tgamesounds);
begin
  if (not assigned(obj)) or (obj.tag < 0) then
    exit;

  ZoneAffichageNiveauDuJeu.setNbVies(NbVies - 1);

  SensDeplacement := TSpriteSensDeplacement.Immobile;
  EnMouvement := TSpriteEnMouvement.non;
  // TODO : ajouter animation explosion
  PlaySound(SoundToPlay);

  // TODO : à traiter après animations de fin de vie
  if (NbVies < 1) then
  begin
    // Il ne reste plus de vies, on dégage le joueur de l'écran
    obj.tag := -1;
    tthread.forcequeue(nil,
      procedure
      begin
        obj.free;
        obj := nil;
      end);
  end
  else
  begin
    // Il reste des vies, on repositionne le joueur à sa place de départ
    x := OrigineX;
    y := OrigineY;
    SensDeplacement := TSpriteSensDeplacement.Immobile;
    EnMouvement := TSpriteEnMouvement.oui;
    // TODO : tester collision, si vaisseau ennemi ou autre à cette place, problème => relancer le niveau complet
  end;
end;

procedure TSpriteJoueur.DoMouvement;
begin
  if EnMouvement = TSpriteEnMouvement.non then
    exit;
  case SensDeplacement of
    TSpriteSensDeplacement.VersLaGauche:
      begin
        if ((x - Vitesse >= 0) and (not HasCollision(x - Vitesse, y))) then
          x := x - Vitesse
        else if (Vitesse > 1) then
          Vitesse := 1
        else
          SensDeplacement := TSpriteSensDeplacement.Immobile;
      end;
    TSpriteSensDeplacement.VersLaDroite:
      begin
        if ((x + Vitesse + obj.width - 1 <= (obj.parent as Tscaledlayout)
          .originalwidth) and (not HasCollision(x + Vitesse, y))) then
          x := x + Vitesse
        else if (Vitesse > 1) then
          Vitesse := 1
        else
          SensDeplacement := TSpriteSensDeplacement.Immobile;
      end;
    TSpriteSensDeplacement.VersLeHaut:
      begin
        if ((y - Vitesse >= 0) and (not HasCollision(x, y - Vitesse))) then
          y := y - Vitesse
        else if (Vitesse > 1) then
          Vitesse := 1
        else
          SensDeplacement := TSpriteSensDeplacement.Immobile;
      end;
    TSpriteSensDeplacement.VersLeBas:
      begin
        if ((y + Vitesse + obj.height - 1 <= (obj.parent as Tscaledlayout)
          .originalheight) and (not HasCollision(x, y + Vitesse))) then
          y := y + Vitesse
        else if (Vitesse > 1) then
          Vitesse := 1
        else
          SensDeplacement := TSpriteSensDeplacement.Immobile;
      end;
  end;
end;

function TSpriteJoueur.HasCollision(AX, AY: single): Boolean;
var
  o: tfmxobject;
  atoucheuntruc: Boolean;
  MyRect: TRectF;
  i: integer;
begin
  result := false;
  MyRect := rectf(AX, AY, AX + obj.width - 1, AY + obj.height - 1);
  for i := obj.parent.Childrencount - 1 downto 0 do
  begin
    // for o in obj.parent.Children do
    o := obj.parent.Children[i];
    if (o <> self.obj) and (o is TControl) and (o.TagObject <> nil) and
      (o.TagObject is tsprite) and (o.tag >= 0) and
      (IntersectRect(MyRect, (o as TControl).BoundsRect)) then
    begin
      atoucheuntruc := true;
      if (o.TagObject is tspritearaignee) then
        self.DoExplose(tgamesounds.KilledBySpider)
      else if (o.TagObject is tspriteennemi) then
      begin
        (o.TagObject as tspriteennemi).DoExplose(tgamesounds.KilledBySpaceship);
        self.DoExplose(tgamesounds.KilledBySpaceship);
      end
      else if (o.TagObject is tspritefleur) then
      begin
        (o.TagObject as tspritefleur).DoExplose(tgamesounds.none);
        self.DoExplose(tgamesounds.KilledByFlower);
      end
      else if (o.TagObject is tspritepiege) then
      begin
        (o.TagObject as tspritepiege).DoExplose(tgamesounds.none);
        self.DoExplose(tgamesounds.KilledByTrap);
      end
      else if (o.TagObject is tspritetir) then
        self.DoExplose(tgamesounds.KilledByLaser)
      else if (o.TagObject is TSpriteChampignon) then
      begin
        atoucheuntruc := false;
        // TODO : son "ramasse un champignon"
        (o.TagObject as TSpriteChampignon).DoExplose(tgamesounds.none);
      end
      else if (o.TagObject is TSpriteBonus) then
      begin
        atoucheuntruc := false;
        // TODO : son "ramassage bonus"
        (o.TagObject as TSpriteBonus).DoExplose(tgamesounds.none);
      end;
      result := result or atoucheuntruc;
    end;
  end;
end;

procedure TSpriteJoueur.LanceExplosif;
var
  o: tfmxobject;
  RectGauche, RectDroite: TRectF;
  i: integer;
begin
  if (NbBombes < 1) then
    exit;

  // TODO : faire animation / affichage bombes (ou feu autour du vaisseau)
  // TODO : son "explosion bombe"

  RectGauche := rectf(x - obj.width / 2, y, x - 1, y + obj.height - 1);
  RectDroite := rectf(x + obj.width, y, x + obj.width + obj.width / 2 - 1,
    y + obj.height - 1);
  for i := obj.parent.Childrencount - 1 downto 0 do
  begin
    // for o in obj.parent.Children do
    o := obj.parent.Children[i];
    if (o <> self.obj) and (o is TControl) and (o.TagObject <> nil) and
      (o.TagObject is tsprite) and (o.tag >= 0) and
      ((IntersectRect(RectGauche, (o as TControl).BoundsRect)) or
      (IntersectRect(RectDroite, (o as TControl).BoundsRect))) then
    begin
      // TODO : permettre d'exploser le fil de l'araignée indépendamment de l'araignée elle-même
      if (o.TagObject is tspritearaignee) and
        (not(o = (o.TagObject as tspritearaignee).FilDeLAraignee)) then
        (o.TagObject as tspritearaignee).DoExplose(tgamesounds.none)
        // TODO : son "araignée tuée par bombe"
      else if (o.TagObject is tspriteennemi) then
        (o.TagObject as tspriteennemi).DoExplose(tgamesounds.KilledBySpaceship)
        // TODO : son "ennemi détruit par bombe"
      else if (o.TagObject is tspritefleur) then
        (o.TagObject as tspritefleur).DoExplose(tgamesounds.none)
        // TODO : son "fleur détruite par bombe"
      else if (o.TagObject is TSpriteChampignon) then
        (o.TagObject as TSpriteChampignon).DoExplose(tgamesounds.none)
        // TODO : son "champignon détruit par bombe"
      else if (o.TagObject is TSpriteBonus) then
        (o.TagObject as TSpriteBonus).DoExplose(tgamesounds.none)
        // TODO : son "bonus détruit par bombe"
      else if (o.TagObject is TSpritemur) then
        (o.TagObject as TSpritemur).DoExplose(tgamesounds.none);
      // TODO : son "mur détruit par bombe"
    end;
  end;

  ZoneAffichageNiveauDuJeu.setNbBombes(NbBombes - 1);
end;

procedure TSpriteJoueur.VaVers(Direction: TSpriteSensDeplacement);
begin
  if ((SensDeplacement = TSpriteSensDeplacement.VersLaGauche) and
    (Direction = TSpriteSensDeplacement.VersLaDroite)) or
    ((SensDeplacement = TSpriteSensDeplacement.VersLaDroite) and
    (Direction = TSpriteSensDeplacement.VersLaGauche)) or
    ((SensDeplacement = TSpriteSensDeplacement.VersLeHaut) and
    (Direction = TSpriteSensDeplacement.VersLeBas)) or
    ((SensDeplacement = TSpriteSensDeplacement.VersLeBas) and
    (Direction = TSpriteSensDeplacement.VersLeHaut)) then
    Vitesse := Vitesse - 1
  else
    SensDeplacement := Direction;
end;

end.
