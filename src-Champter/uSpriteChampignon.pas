unit uSpriteChampignon;

interface

uses
  fmx.controls, uSprite;

type
  TSpriteChampignon = class(tsprite)
  public
    class function AjouteChampignon(AParent: TControl; AX, AY: single)
      : TSpriteChampignon;
    procedure DoExplose; override;
  end;

implementation

uses
  system.classes, fmx.objects, fmx.graphics, uDMImages, system.types,
  Champter.Consts, uPartieEnCours;

{ TSpriteChampignon }

class function TSpriteChampignon.AjouteChampignon(AParent: TControl;
  AX, AY: single): TSpriteChampignon;
var
  r: trectangle;
  taille: tsizef;
begin
  result := TSpriteChampignon.Create;
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
  // indices des champignons : 3 .. 11
  r.fill.bitmap.bitmap.Assign(dmimages.imgsprites.bitmap(taille, 3));
  result.obj := r;
  // Incrémente le nombre de champignons à l'écran
  inc(NbChampignonsARamasser);
end;

procedure TSpriteChampignon.DoExplose;
begin
  if (not assigned(obj)) or (obj.tag < 0) then
    exit;

  // change le score du joueur
  ZoneAffichageNiveauDuJeu.setScore(score + cScoreChampignonRamasse);

  // diminue le nombre de champignons à ramasser dans cet écran
  dec(NbChampignonsARamasser);

  // retire le chapignon de l'écran
  obj.tag := -1;
  tthread.forcequeue(nil,
    procedure
    begin
      obj.free;
      obj := nil;
    end);
end;

end.
