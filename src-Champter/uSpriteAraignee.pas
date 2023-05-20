unit uSpriteAraignee;

interface

uses
  fmx.controls, fmx.objects, uSprite;

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
    procedure DoExplose; override;
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
  // images anim�es : 1, 2
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

procedure TSpriteAraignee.DoExplose;
begin
  // TODO : g�rer le fait que l'araign�e a �t� tu�e par un tir de laser ou une bombe du joueur
  SensDeplacement := TSpriteSensDeplacement.Immobile;
  EnMouvement := TSpriteEnMouvement.non;
  (obj as trectangle).fill.bitmap.bitmap.Assign
    (dmimages.imgsprites.bitmap((obj as trectangle).size.size, 27));
  // TODO : ajouter un bruitage "araign�e cuite ou tu�e par missile / bombe"

  // TODO : ajouter une tempo avant suppression de l'image de l'araign�e

  // TODO : ajouter un bonus � l'emplacement de l'araign�e apr�s quelques secondes

  obj.Tag := -1; // on d�sactive le fonctionement des mouvements sur l'araign�e
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

  // animation de l'araign�e en changeant l'image associ�e
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
        (o.TagObject as tspritejoueur).DoExplose
      else if (o.TagObject is tspriteennemi) then
        (o.TagObject as tspriteennemi).DoExplose;
    end;
  end;
end;

initialization

randomize;

end.
