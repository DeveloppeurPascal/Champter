unit uSpriteMur;

interface

uses
  fmx.controls, uSprite;

type
  TSpriteMur = class(tsprite)
  public
    class function AjouteMur(AParent: TControl; AX, AY: single): TSpriteMur;
    procedure DoExplose; override;
  end;

implementation

uses
  system.classes, fmx.objects, fmx.graphics, uDMImages, system.types,
  Champter.Consts, uPartieEnCours;

{ TSpriteMur }

class function TSpriteMur.AjouteMur(AParent: TControl; AX, AY: single)
  : TSpriteMur;
var
  r: trectangle;
  taille: tsizef;
begin
  result := TSpriteMur.Create;
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
  // indices des murs / verdure : 12..17
  r.fill.bitmap.bitmap.Assign(dmimages.imgsprites.bitmap(taille,
    random(2) + 16));
  result.obj := r;
end;

procedure TSpriteMur.DoExplose;
begin
  if (not assigned(obj)) or (obj.tag < 0) then
    exit;

  ZoneAffichageNiveauDuJeu.setScore(score + cscoreMurDetruit);

  // TODO : animation explosion

  obj.tag := -1;
  tthread.forcequeue(nil,
    procedure
    begin
      obj.free;
      obj := nil;
    end);
end;

initialization

randomize;

end.
