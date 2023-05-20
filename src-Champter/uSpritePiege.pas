unit uSpritePiege;

interface

uses
  fmx.controls, fmx.ani, uSprite;

type
  TSpritePiege = class(tsprite)
  private
    Visibilite: tfloatanimation;
    procedure VisibiliteFinie(Sender: Tobject);
  public
    class function AjoutePiege(AParent: TControl; AX, AY: single): TSpritePiege;
    procedure DoMouvement; override;
    procedure DoExplose; override;
  end;

implementation

uses
  fmx.types, fmx.objects, fmx.graphics, uDMImages, system.types,
  Champter.Consts,
  system.UITypes;

{ TSpritePiege }

class function TSpritePiege.AjoutePiege(AParent: TControl; AX, AY: single)
  : TSpritePiege;
var
  r: trectangle;
  taille: tsizef;
begin
  result := TSpritePiege.Create;
  result.x := AX + 5; // marge de 5px autour du piège
  result.y := AY + 5; // marge de 5px autour du piège
  r := trectangle.Create(AParent);
  r.parent := AParent;
  r.stroke.Kind := tbrushkind.solid;
  r.stroke.Color := talphacolors.darkgray;
  r.fill.Kind := tbrushkind.solid;
  r.fill.Color := talphacolors.Darkred;
  r.Opacity := 0.1;
  taille.width := cNbPixelsParCase - 5 * 2; // marge de 5px autour du piège
  taille.height := cNbPixelsParCase - 5 * 2; // marge de 5px autour du piège
  r.size.size := taille;
  result.obj := r;
  result.EnMouvement := TSpriteEnMouvement.oui;
  result.Visibilite := tfloatanimation.Create(AParent);
  result.Visibilite.parent := r;
  result.Visibilite.PropertyName := 'Opacity';
  result.Visibilite.StartValue := 0;
  result.Visibilite.StopValue := 1;
  result.Visibilite.Interpolation := TInterpolationType.bounce;
  result.Visibilite.OnFinish := result.VisibiliteFinie;
end;

procedure TSpritePiege.DoExplose;
begin
  // TODO : animation de déclenchement du piège
end;

procedure TSpritePiege.DoMouvement;
begin
  if (random(10000) < 100) and (not Visibilite.enabled) then
  begin
    Visibilite.StopValue := (random(9) + 2) / 10;
    Visibilite.enabled := true;
  end;
end;

procedure TSpritePiege.VisibiliteFinie(Sender: Tobject);
begin
  Visibilite.enabled := false;
  if not Visibilite.Inverse then
  begin
    Visibilite.Inverse := true;
    Visibilite.enabled := true;
  end
  else
    Visibilite.Inverse := false;
end;

initialization

randomize;

end.
