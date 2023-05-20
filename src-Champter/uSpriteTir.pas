unit uSpriteTir;

interface

uses
  fmx.controls, uSprite;

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
        (o.TagObject as tspritejoueur).DoExplose
      else if (o.TagObject is tspriteennemi) then
        (o.TagObject as tspriteennemi).DoExplose
      else if (o.TagObject is tspritearaignee) and
        (not(o = (o.TagObject as tspritearaignee).FilDeLAraignee)) then
        (o.TagObject as tspritearaignee).DoExplose;
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
        // TODO : déclenche un bruit
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
