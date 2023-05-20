unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  fAncetreFicheTraduite;

type
  T_AncetreFicheTraduite1 = class(T_AncetreFicheTraduite)
  private
    { Déclarations privées }
  public
      procedure TraduireTextes; override;
    { Déclarations publiques }

  end;

var
  _AncetreFicheTraduite1: T_AncetreFicheTraduite1;

implementation

{$R *.fmx}

uses uDMTraductions;

{ T_AncetreFicheTraduite1 }

procedure T_AncetreFicheTraduite1.TraduireTextes;
begin
  inherited;
  caption := _('TitreDuJeu', 'Champter Editor'); // TODO : traduire le texte
end;

end.
