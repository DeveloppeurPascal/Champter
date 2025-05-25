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
  Signature : 1e7537f7debfdb2062508307f89594664c7f8f8d
  ***************************************************************************
*)

unit uSpriteMur;

interface

uses
  fmx.controls, uSprite, uSoundsAndMusics;

type
  TSpriteMur = class(tsprite)
  public
    class function AjouteMur(AParent: TControl; AX, AY: single): TSpriteMur;
    procedure DoExplose(SoundToPlay: tgamesounds); override;
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

procedure TSpriteMur.DoExplose(SoundToPlay: tgamesounds);
begin
  if (not assigned(obj)) or (obj.tag < 0) then
    exit;

  // TODO : envisager animation de suppression du mur
  playsound(SoundToPlay);

  ZoneAffichageNiveauDuJeu.setScore(score + cscoreMurDetruit);

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
