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
  Signature : 3b69ac9abb728908e51ed0214491cdb5b0544d0d
  ***************************************************************************
*)

unit uSpriteTir;

interface

uses
  fmx.controls, uSprite, uSoundsAndMusics;

type
  TSpriteTir = class(tsprite)
  private
    FCompteur: word;
    FVisible: boolean;
    procedure SetCompteur(const Value: word);
    procedure SetVisible(const Value: boolean);
  public
    /// <summary>
    /// Compteur de tics depuis le dernier changement d'état
    /// </summary>
    property Compteur: word read FCompteur write SetCompteur;
    /// <summary>
    /// Gère la visibilité du tir
    /// </summary>
    property Visible: boolean read FVisible write SetVisible;
    /// <summary>
    /// Ajoute un nouveau "tir de laser" à l'écran
    /// </summary>
    class function AjouteTir(AParent: TControl; AX, AY: single): TSpriteTir;
    /// <summary>
    /// gère les animations du tir de laser en fonction de son état
    /// </summary>
    procedure DoMouvement; override;
    /// <summary>
    /// Vérifie si on touche des éléments du jeu lors de l'affichage du tir de laser
    /// </summary>
    function HasCollision(AX: single; AY: single): boolean; override;
    /// <summary>
    /// Compteur à atteindre pour afficher ou masquer le tir selon son état actuel
    /// </summary>
    function CompteurDureeDAffichage: word;
  end;

implementation

uses
  fmx.types, fmx.objects, fmx.graphics, uDMImages, system.types,
  Champter.Consts,
  system.UITypes, uSpriteAraignee, USpriteEnnemi, uSpriteJoueur;

{ TSpriteTir }

class function TSpriteTir.AjouteTir(AParent: TControl; AX, AY: single)
  : TSpriteTir;
var
  l: tline;
  taille: tsizef;
begin
  result := TSpriteTir.Create;
  result.x := AX + 5; // décalage de 5px vers la droite en guise de marge
  result.y := AY + (cNbPixelsParCase - 5) / 2;
  l := tline.Create(AParent);
  l.parent := AParent;
  l.LineType := tlinetype.top;
  l.stroke.Kind := tbrushkind.solid;
  l.stroke.Color := talphacolors.orange;
  l.fill.Kind := tbrushkind.none;
  taille.width := cNbPixelsParCase - 10;
  // marge de 5 à gauche et à droite du tir
  taille.height := 5;
  l.size.size := taille;
  l.stroke.Thickness := taille.height;
  result.obj := l;
  result.EnMouvement := TSpriteEnMouvement.oui;
  result.FVisible := true;
  result.FCompteur := 0;
end;

function TSpriteTir.CompteurDureeDAffichage: word;
begin
  result := trunc(obj.width) + cNbPixelsParCase * 2 (* largeur du joueur *) +
    random(cNbPixelsParCase) + cNbPixelsParCase div 2;
end;

procedure TSpriteTir.DoMouvement;
begin
  Compteur := Compteur + 1;
end;

function TSpriteTir.HasCollision(AX, AY: single): boolean;
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
      (o.TagObject is tsprite) and (o.Tag >= 0) and
      (IntersectRect(MyRect, (o as TControl).BoundsRect)) then
    begin
      result := true;
      if (o.TagObject is tspritejoueur) then
        (o.TagObject as tspritejoueur).DoExplose(tgamesounds.KilledByLaser)
      else if (o.TagObject is tspriteennemi) then
        (o.TagObject as tspriteennemi).DoExplose(tgamesounds.KilledByLaser)
      else if (o.TagObject is tspritearaignee) and
        (not(o = (o.TagObject as tspritearaignee).FilDeLAraignee)) then
        (o.TagObject as tspritearaignee).DoExplose(tgamesounds.KilledByLaser);
      // TODO : son "araignée tuée par laser"
    end;
  end;
end;

procedure TSpriteTir.SetCompteur(const Value: word);
begin
  FCompteur := Value;
  if (FCompteur > CompteurDureeDAffichage) then
  begin
    Visible := not Visible;
    FCompteur := 0;
  end;
end;

procedure TSpriteTir.SetVisible(const Value: boolean);
begin
  if (FVisible <> Value) then
  begin
    FVisible := Value;
    obj.Visible := FVisible;
    if FVisible then
    begin
      obj.Tag := 0;
      obj.bringtofront;
      if HasCollision(x, y) then
      begin
        playsound(tgamesounds.LaserShow);
        // TODO : déclenche une animation sur la couleur du tir
      end;
    end
    else
      obj.Tag := -1;
  end;
end;

initialization

randomize;

end.
