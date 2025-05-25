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
  Signature : 1729a6fbea474c73d6a4b3e6ff93e2b0fb3d7540
  ***************************************************************************
*)

unit uSpriteChampignon;

interface

uses
  fmx.controls, uSprite, uSoundsAndMusics;

type
  TSpriteChampignon = class(tsprite)
  public
    class function AjouteChampignon(AParent: TControl; AX, AY: single)
      : TSpriteChampignon;
    procedure DoExplose(SoundToPlay: tgamesounds); override;
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
  // Incr�mente le nombre de champignons � l'�cran
  inc(NbChampignonsARamasser);
end;

procedure TSpriteChampignon.DoExplose(SoundToPlay: tgamesounds);
begin
  if (not assigned(obj)) or (obj.tag < 0) then
    exit;

  // TODO : voir si animation de la r�colte du champignon utile
  playsound(SoundToPlay);

  // change le score du joueur
  ZoneAffichageNiveauDuJeu.setScore(score + cScoreChampignonRamasse);

  // diminue le nombre de champignons � ramasser dans cet �cran
  dec(NbChampignonsARamasser);

  // retire le champignon de l'�cran
  obj.tag := -1;
  tthread.forcequeue(nil,
    procedure
    begin
      obj.free;
      obj := nil;
    end);
end;

end.
