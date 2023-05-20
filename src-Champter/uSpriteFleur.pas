unit uSpriteFleur;

interface

uses
  fmx.controls, uSprite;

type
  TSpriteFleur = class(tsprite)
  public
    class function AjouteFleur(AParent: TControl; AX, AY: single): TSpriteFleur;
    procedure DoExplose; override;
  end;

implementation

uses
  system.classes, fmx.objects, fmx.graphics, uDMImages, system.types,
  Champter.Consts, uPartieEnCours;

{ TSpriteFleur }

class function TSpriteFleur.AjouteFleur(AParent: TControl; AX, AY: single)
  : TSpriteFleur;
var
  r: trectangle;
  taille: tsizef;
begin
  result := TSpriteFleur.Create;
  result.x := AX;
  result.y := AY;
  r := trectangle.Create(AParent);
  r.parent := AParent;
  r.stroke.Kind := tbrushkind.none;
  r.fill.Kind := tbrushkind.bitmap;
  taille.width := cNbPixelsParCase;
  taille.height := cNbPixelsParCase;
  r.size.size := taille;
  r.fill.bitmap.WrapMode := TWrapMode.TileStretch;
  r.fill.bitmap.bitmap.Assign(dmimages.imgsprites.bitmap(taille, 20));
  result.obj := r;
end;

procedure TSpriteFleur.DoExplose;
begin
  if (not assigned(obj)) or (obj.tag < 0) then
    exit;

  ZoneAffichageNiveauDuJeu.setScore(score + cScoreFleurDetruite);

  // TODO : faire éventuellement une animation sur la fleur, puis la supprimer

  obj.tag := -1;
  tthread.forcequeue(nil,
    procedure
    begin
      obj.free;
      obj := nil;
    end);
end;

end.
