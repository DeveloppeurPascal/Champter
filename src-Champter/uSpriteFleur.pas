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
  Signature : 6e4c411222d59181bfebd29ddcd4f9d4dd162335
  ***************************************************************************
*)

unit uSpriteFleur;

interface

uses
  fmx.controls, uSprite, uSoundsAndMusics;

type
  TSpriteFleur = class(tsprite)
  public
    class function AjouteFleur(AParent: TControl; AX, AY: single): TSpriteFleur;
    procedure DoExplose(SoundToPlay: tgamesounds); override;
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

procedure TSpriteFleur.DoExplose(SoundToPlay: tgamesounds);
begin
  if (not assigned(obj)) or (obj.tag < 0) then
    exit;

  playsound(SoundToPlay);

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
