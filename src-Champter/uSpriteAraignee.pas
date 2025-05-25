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
  File last update : 2025-05-25T09:31:36.630+02:00
  Signature : 61c7e1b8962dffa80a3391d33b9f14660d8b0661
  ***************************************************************************
*)

unit uSpriteAraignee;

interface

uses
  fmx.controls, fmx.objects, uSprite, uSoundsAndMusics;

type
  TSpriteAraignee = class(tsprite)
  private
    OrigineY: single;
  public
    FilDeLAraignee: TLine;
    class function AjouteAraignee(AParent: TControl; AX, AY: single)
      : TSpriteAraignee;
    procedure DoMouvement; override;
    function HasCollision(AX: single; AY: single): Boolean; override;
    procedure DoExplose(SoundToPlay: tgamesounds); override;
  end;

implementation

uses
  system.classes, fmx.graphics, uDMImages, system.types, system.uitypes,
  Champter.Consts, fmx.types, uSpriteJoueur, USpriteEnnemi,
  uSpriteTir, uPartieEnCours, fmx.layouts;

{ TSpriteAraignee }

class function TSpriteAraignee.AjouteAraignee(AParent: TControl; AX, AY: single)
  : TSpriteAraignee;
var
  r: trectangle;
  taille: tsizef;
begin
  result := TSpriteAraignee.Create;
  result.x := AX;
  result.y := AY;
  result.OrigineY := AY;
  r := trectangle.Create(AParent);
  r.parent := AParent;
  r.stroke.Kind := tbrushkind.none;
  r.fill.Kind := tbrushkind.bitmap;
  taille.width := cNbPixelsParCase;
  taille.height := cNbPixelsParCase;
  r.size.size := taille;
  // images animées : 1, 2
  r.fill.bitmap.WrapMode := TWrapMode.TileStretch;
  r.fill.bitmap.bitmap.Assign(dmimages.imgsprites.bitmap(taille, 1));
  result.obj := r;
  result.EnMouvement := TSpriteEnMouvement.oui;
  result.FilDeLAraignee := TLine.Create(AParent);
  result.FilDeLAraignee.parent := AParent;
  result.FilDeLAraignee.LineType := tlinetype.Left;
  result.FilDeLAraignee.stroke.Kind := tbrushkind.solid;
  result.FilDeLAraignee.stroke.Color := talphacolors.beige;
  result.FilDeLAraignee.fill.Kind := tbrushkind.none;
  result.FilDeLAraignee.size.size := tsizef.Create(5, cNbPixelsParCase / 2);
  result.FilDeLAraignee.stroke.Thickness := 5;
  result.FilDeLAraignee.Position.x := AX + (cNbPixelsParCase - 5) / 2;
  result.FilDeLAraignee.Position.y := AY;
  result.FilDeLAraignee.TagObject := result;
  result.obj.BringToFront;
end;

procedure TSpriteAraignee.DoExplose(SoundToPlay: tgamesounds);
begin
  // TODO : gérer le fait que l'araignée a été tuée par un tir de laser ou une bombe du joueur
  SensDeplacement := TSpriteSensDeplacement.Immobile;
  EnMouvement := TSpriteEnMouvement.non;
  (obj as trectangle).fill.bitmap.bitmap.Assign
    (dmimages.imgsprites.bitmap((obj as trectangle).size.size, 27));

  playsound(SoundToPlay);

  // TODO : ajouter une tempo avant suppression de l'image de l'araignée

  // TODO : ajouter un bonus à l'emplacement de l'araignée après quelques secondes

  obj.Tag := -1; // on désactive le fonctionement des mouvements sur l'araignée
  FilDeLAraignee.free;
  FilDeLAraignee := nil;

  ZoneAffichageNiveauDuJeu.setScore(score + cScoreAraigneeTuee);
end;

procedure TSpriteAraignee.DoMouvement;
begin
  if EnMouvement = TSpriteEnMouvement.non then
    exit;

  if SensDeplacement = TSpriteSensDeplacement.VersLeHaut then
  begin
    if ((y - Vitesse > OrigineY) and (not HasCollision(x, y - Vitesse))) then
    begin
      y := y - Vitesse;
      FilDeLAraignee.height := FilDeLAraignee.height - Vitesse;
    end
    else
    begin
      SensDeplacement := TSpriteSensDeplacement.VersLebas;
      Vitesse := random(3) + 1;
    end;
  end
  else if SensDeplacement = TSpriteSensDeplacement.VersLebas then
  begin
    if (y + Vitesse + obj.height - 1 <= (obj.parent as Tscaledlayout)
      .originalheight) and (not HasCollision(x, y + Vitesse)) then
    begin
      y := y + Vitesse;
      FilDeLAraignee.height := FilDeLAraignee.height + Vitesse;
    end
    else
    begin
      SensDeplacement := TSpriteSensDeplacement.VersLeHaut;
      Vitesse := random(3) + 1;
    end;
  end
  else
  begin
    SensDeplacement := TSpriteSensDeplacement.VersLebas;
    Vitesse := random(3) + 1;
  end;

  // animation de l'araignée en changeant l'image associée
  if (random(1000) < 100) then
    (obj as trectangle).fill.bitmap.bitmap.Assign
      (dmimages.imgsprites.bitmap((obj as trectangle).size.size,
      random(2) + 1));
end;

function TSpriteAraignee.HasCollision(AX, AY: single): Boolean;
var
  o: tfmxobject;
  MyRect: TRectF;
  i: integer;
begin
  result := false;
  MyRect := rectf(AX, AY, AX + obj.width - 1, AY + obj.height - 1);
  for i := obj.parent.Childrencount - 1 downto 0 do
  begin
    // for o in obj.parent.Children do
    o := obj.parent.Children[i];
    if (o <> self.obj) and (o <> FilDeLAraignee) and (o is TControl) and
      (o.TagObject <> nil) and (o.TagObject is tsprite) and (o.Tag >= 0) and
      (IntersectRect(MyRect, (o as TControl).BoundsRect)) then
    begin
      result := true;
      if (o.TagObject is tspritejoueur) then
        (o.TagObject as tspritejoueur).DoExplose(tgamesounds.KilledBySpider)
      else if (o.TagObject is tspriteennemi) then
        (o.TagObject as tspriteennemi).DoExplose(tgamesounds.KilledBySpider);
    end;
  end;
end;

initialization

randomize;

end.
