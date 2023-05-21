unit USpriteEnnemi;

interface

uses
  fmx.controls, uSprite, uSoundsAndMusics;

type
  TSpriteEnnemi = class(tsprite)
  public
    class function AjouteEnnemi(AParent: TControl; AX, AY: single)
      : TSpriteEnnemi;
    procedure DoMouvement; override;
    function HasCollision(AX: single; AY: single): Boolean; override;
    procedure DoExplose(SoundToPlay: tgamesounds); override;
    procedure ChangementDeDirection;
  end;

implementation

uses
  fmx.layouts, system.classes, fmx.types, fmx.objects, fmx.graphics, uDMImages,
  system.types,
  Champter.Consts, fmx.Filter.Effects, uSpritePiege, uPartieEnCours;

{ TSpriteEnnemi }

class function TSpriteEnnemi.AjouteEnnemi(AParent: TControl; AX, AY: single)
  : TSpriteEnnemi;
var
  r: trectangle;
  f: TInvertEffect;
  taille: tsizef;
begin
  result := TSpriteEnnemi.Create;
  result.x := AX;
  result.y := AY;
  r := trectangle.Create(AParent);
  r.parent := AParent;
  r.stroke.Kind := tbrushkind.none;
  r.fill.Kind := tbrushkind.bitmap;
  taille.width := 2 * cNbPixelsParCase;
  taille.height := cNbPixelsParCase;
  r.size.size := taille;
  r.fill.bitmap.WrapMode := TWrapMode.TileStretch;
  r.fill.bitmap.bitmap.Assign(dmimages.imgsprites.bitmap(taille, 0));
  f := TInvertEffect.Create(r);
  f.parent := r;
  f.Enabled := true;
  result.obj := r;
  result.EnMouvement := TSpriteEnMouvement.oui;
end;

procedure TSpriteEnnemi.ChangementDeDirection;
begin
  case random(5) of
    0:
      SensDeplacement := TSpriteSensDeplacement.VersLeHaut;
    1:
      SensDeplacement := TSpriteSensDeplacement.VersLaDroite;
    2:
      SensDeplacement := TSpriteSensDeplacement.VersLeBas;
    3:
      SensDeplacement := TSpriteSensDeplacement.VersLaGauche;
  else
    SensDeplacement := TSpriteSensDeplacement.Immobile;
  end;
  if not(SensDeplacement = TSpriteSensDeplacement.Immobile) then
    Vitesse := random(5) + 1;
end;

procedure TSpriteEnnemi.DoExplose(SoundToPlay: tgamesounds);
begin
  if (not assigned(obj)) or (obj.tag < 0) then
    exit;

  SensDeplacement := TSpriteSensDeplacement.Immobile;
  EnMouvement := TSpriteEnMouvement.non;
  // TODO : ajouter animation explosion
  playsound(SoundToPlay);

  ZoneAffichageNiveauDuJeu.setScore(score + cScoreEnnemiDetruit);
  // TODO : ajouter un bonus à l'emplacement du vaisseau ennemi

  // TODO : à retirer une fois les animations de fin effectuées
  obj.tag := -1;
  tthread.forcequeue(nil,
    procedure
    begin
      obj.free;
      obj := nil;
    end);
end;

procedure TSpriteEnnemi.DoMouvement;
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
          ChangementDeDirection;
      end;
    TSpriteSensDeplacement.VersLaDroite:
      begin
        if ((x + Vitesse + obj.width - 1 <= (obj.parent as Tscaledlayout)
          .originalwidth) and (not HasCollision(x + Vitesse, y))) then
          x := x + Vitesse
        else if (Vitesse > 1) then
          Vitesse := 1
        else
          ChangementDeDirection;
      end;
    TSpriteSensDeplacement.VersLeHaut:
      begin
        if ((y - Vitesse >= 0) and (not HasCollision(x, y - Vitesse))) then
          y := y - Vitesse
        else if (Vitesse > 1) then
          Vitesse := 1
        else
          ChangementDeDirection;
      end;
    TSpriteSensDeplacement.VersLeBas:
      begin
        if ((y + Vitesse + obj.height - 1 <= (obj.parent as Tscaledlayout)
          .originalheight) and (not HasCollision(x, y + Vitesse))) then
          y := y + Vitesse
        else if (Vitesse > 1) then
          Vitesse := 1
        else
          ChangementDeDirection;
      end;
  else
    if (random(100) < 20) then
      ChangementDeDirection;
  end;
end;

function TSpriteEnnemi.HasCollision(AX, AY: single): Boolean;
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
    if (o <> self.obj) and (o is TControl) and (o.TagObject <> nil) and
      (o.TagObject is tsprite) and (o.tag >= 0) and
      (IntersectRect(MyRect, (o as TControl).BoundsRect)) then
    begin
      result := true;
      if (o.TagObject is tspritepiege) then
      begin
        (o.TagObject as tspritepiege).DoExplose(tgamesounds.none);
        self.DoExplose(tgamesounds.KilledByTrap);
      end;
    end;
  end;
end;

initialization

randomize;

end.
