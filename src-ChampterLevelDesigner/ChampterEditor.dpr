program ChampterEditor;

uses
  System.StartUpCopy,
  FMX.Forms,
  fAncetreCadreTraduit in '..\src-libTraductions\fAncetreCadreTraduit.pas' {_AncetreCadreTraduit: TFrame},
  fAncetreFicheTraduite in '..\src-libTraductions\fAncetreFicheTraduite.pas' {_AncetreFicheTraduite},
  uDMTraductions in '..\src-libTraductions\uDMTraductions.pas' {dmTraductions: TDataModule},
  fMain in 'fMain.pas' {_AncetreFicheTraduite1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(T_AncetreFicheTraduite1, _AncetreFicheTraduite1);
  Application.Run;
end.
