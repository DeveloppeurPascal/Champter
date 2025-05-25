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
  Signature : 1c6027d5e59042b80870e9417e169b172787b551
  ***************************************************************************
*)

unit uSprite;

interface

uses
  fmx.controls, System.Generics.Collections, uSoundsAndMusics;

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
    procedure DoExplose(SoundToPlay: tgamesounds); virtual; abstract;
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
