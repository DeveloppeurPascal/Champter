unit uSprite;

interface

uses
  fmx.controls, System.Generics.Collections;

type
{$SCOPEDENUMS on}
  TSpriteSensDeplacement = (Immobile, VersLaGauche, VersLaDroite, VersLeHaut,
    VersLeBas);

  TSpriteEnMouvement = (oui, non);

  TSprite = class
  private
    FObj: TControl;
    FX: single;
    FY: single;
    FSensDeplacement: TSpriteSensDeplacement;
    FEnMouvement: TSpriteEnMouvement;
    FVitesse: single;
    procedure Setobj(const Value: TControl);
    procedure Setx(const Value: single);
    procedure Sety(const Value: single);
    procedure SetSensDeplacement(const Value: TSpriteSensDeplacement);
    procedure SetEnMouvement(const Value: TSpriteEnMouvement);
    procedure SetVitesse(const Value: single);
  public
    property X: single read FX write Setx;
    property Y: single read FY write Sety;
    property Vitesse: single read FVitesse write SetVitesse;
    property obj: TControl read FObj write Setobj;
    property SensDeplacement: TSpriteSensDeplacement read FSensDeplacement
      write SetSensDeplacement;
    property EnMouvement: TSpriteEnMouvement read FEnMouvement
      write SetEnMouvement;
    procedure DoMouvement; virtual; abstract;
    procedure DoExplose; virtual; abstract;
    function HasCollision(AX, AY: single): boolean; virtual; abstract;
    constructor Create; virtual;
  end;

  TSpriteList = TObjectList<TSprite>;

implementation

uses
  System.types;

{ TSprite }

constructor TSprite.Create;
begin
  FX := 0;
  FY := 0;
  FObj := nil;
  FSensDeplacement := TSpriteSensDeplacement.Immobile;
  FVitesse := 0;
  FEnMouvement := TSpriteEnMouvement.non;
end;

procedure TSprite.SetEnMouvement(const Value: TSpriteEnMouvement);
begin
  FEnMouvement := Value;
end;

procedure TSprite.Setobj(const Value: TControl);
begin
  FObj := Value;
  if (FObj <> nil) then
  begin
    FObj.Position.Point := pointf(FX, FY);
    FObj.HitTest := false;
    FObj.tagobject := self;
  end;
end;

procedure TSprite.SetSensDeplacement(const Value: TSpriteSensDeplacement);
begin
  if (Value = TSpriteSensDeplacement.Immobile) then
  begin
    FSensDeplacement := TSpriteSensDeplacement.Immobile;
    FVitesse := 0;
  end
  else if (FSensDeplacement <> Value) then
  begin
    FSensDeplacement := Value;
    FVitesse := 1;
  end
  else
    FVitesse := FVitesse + 1;
end;

procedure TSprite.SetVitesse(const Value: single);
begin
  FVitesse := Value;
  if FVitesse = 0 then
    FSensDeplacement := TSpriteSensDeplacement.Immobile;
end;

procedure TSprite.Setx(const Value: single);
begin
  FX := Value;
  if (FObj <> nil) then
    FObj.Position.Point := pointf(FX, FY);
end;

procedure TSprite.Sety(const Value: single);
begin
  FY := Value;
  if (FObj <> nil) then
    FObj.Position.Point := pointf(FX, FY);
end;

end.
