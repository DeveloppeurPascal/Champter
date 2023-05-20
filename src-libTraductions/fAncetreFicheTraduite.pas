unit fAncetreFicheTraduite;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  T_AncetreFicheTraduite = class(TForm)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent); override;
    procedure TraduireTextes; virtual;
  end;

implementation

{$R *.fmx}

uses
  uDMTraductions;

{ TFormTraduite }

constructor T_AncetreFicheTraduite.Create(AOwner: TComponent);
begin
  inherited;
  tthread.ForceQueue(nil,
    procedure
    begin
      TraduireTextes;
    end);
end;

procedure T_AncetreFicheTraduite.TraduireTextes;
var
  i: integer;
begin
  for i := 0 to Componentcount-1 do
    if (components[i] is TPresentedTextControl) then
      (components[i] as TPresentedTextControl).text :=
        _(Name + '.' + components[i].Name,
        (components[i] as TPresentedTextControl).text);
end;

end.
