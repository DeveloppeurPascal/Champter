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
  File last update : 2025-05-25T09:31:36.630+02:00
  Signature : a67d98cb5035ba53b9df37e6c6f6a6853de97cb0
  ***************************************************************************
*)

unit uSpriteBonus;

interface

uses
  fmx.controls, uSprite, uSoundsAndMusics;

type
{$SCOPEDENUMS on}
  TBonusType = (Score, Bombe, Temps, Vie);

  TSpriteBonus = class(tsprite)
  private
    Fbonustype: TBonusType;
    procedure Setbonustype(const Value: TBonusType);
  public
    property bonustype: TBonusType read Fbonustype write Setbonustype;
    class function AjouteBonus(AParent: TControl; AX, AY: single;
      ABonusType: TBonusType): TSpriteBonus;
    procedure DoExplose(SoundToPlay: tgamesounds); override;
  end;

implementation

uses
  system.classes, fmx.objects, fmx.graphics, uDMImages, system.types,
  Champter.Consts, uPartieEnCours;

{ TSpriteBonus }

class function TSpriteBonus.AjouteBonus(AParent: TControl; AX, AY: single;
  ABonusType: TBonusType): TSpriteBonus;
var
  r: trectangle;
  taille: tsizef;
begin
  result := TSpriteBonus.Create;
  result.x := AX;
  result.y := AY;
  result.bonustype := ABonusType;
  r := trectangle.Create(AParent);
  r.parent := AParent;
  r.stroke.Kind := tbrushkind.none;
  r.fill.Kind := tbrushkind.bitmap;
  taille.width := cNbPixelsParCase;
  taille.height := cNbPixelsParCase;
  r.size.size := taille;
  // images : 21..26
  r.fill.bitmap.WrapMode := TWrapMode.TileStretch;
  r.fill.bitmap.bitmap.Assign(dmimages.imgsprites.bitmap(taille,
    random(6) + 21));
  result.obj := r;
end;

procedure TSpriteBonus.DoExplose(SoundToPlay: tgamesounds);
begin
  if (not assigned(obj)) or (obj.tag < 0) then
    exit;

  playsound(SoundToPlay);

  case bonustype of
    TBonusType.Score:
      ZoneAffichageNiveauDuJeu.setScore(Score + random(400) + 100);
    TBonusType.Bombe:
      begin
        ZoneAffichageNiveauDuJeu.setScore(Score + cScoreBonusBombeRamassee);
        ZoneAffichageNiveauDuJeu.setNbBombes(nbbombes + random(5) + 1);
      end;
    TBonusType.Vie:
      begin
        ZoneAffichageNiveauDuJeu.setScore(Score + cScoreBonusvieramassee);
        ZoneAffichageNiveauDuJeu.setNbVies(NbVies + 1);
      end;
    TBonusType.Temps:
      begin
        ZoneAffichageNiveauDuJeu.setScore(Score + cScoreBonusTempsRamasse);
        // TODO : incrémenter le temps restant
      end;
  end;

  // TODO : animation indiquant ce qu'on a gagné

  obj.tag := -1;
  tthread.forcequeue(nil,
    procedure
    begin
      obj.free;
      obj := nil;
    end);
end;

procedure TSpriteBonus.Setbonustype(const Value: TBonusType);
begin
  Fbonustype := Value;
end;

end.
