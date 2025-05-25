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
  Signature : e6711db2594354970845dcae1e2a723cabc82df4
  ***************************************************************************
*)

unit uSpritePiege;

interface

uses
  fmx.controls, fmx.ani, uSprite, uSoundsAndMusics;

type
  TSpritePiege = class(tsprite)
  private
    Visibilite: tfloatanimation;
    procedure VisibiliteFinie(Sender: Tobject);
  public
    class function AjoutePiege(AParent: TControl; AX, AY: single): TSpritePiege;
    procedure DoMouvement; override;
    procedure DoExplose(SoundToPlay: tgamesounds); override;
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

procedure TSpritePiege.DoExplose(SoundToPlay: tgamesounds);
begin
  // TODO : animation de déclenchement du piège
  playsound(SoundToPlay);
end;

procedure TSpritePiege.DoMouvement;
begin
  if (random(10000) < 100) and (not Visibilite.enabled) then
  begin
    Visibilite.StopValue := (random(9) + 2) / 10;
    Visibilite.enabled := true;
    playsound(tgamesounds.TrapShow);
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
