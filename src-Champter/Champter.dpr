program Champter;

uses
  System.StartUpCopy,
  FMX.Forms,
  fAncetreCadreTraduit in '..\src-libTraductions\fAncetreCadreTraduit.pas' {_AncetreCadreTraduit: TFrame},
  fAncetreFicheTraduite in '..\src-libTraductions\fAncetreFicheTraduite.pas' {_AncetreFicheTraduite},
  uDMTraductions in '..\src-libTraductions\uDMTraductions.pas' {dmTraductions: TDataModule},
  fMain in 'fMain.pas' {frmMain},
  Champter.Types in 'Champter.Types.pas',
  Champter.Consts in 'Champter.Consts.pas',
  cDessinNiveau in 'cDessinNiveau.pas' {zoneDessinNiveau: TFrame},
  uPartieEnCours in 'uPartieEnCours.pas',
  uSprite in 'uSprite.pas',
  uDMImages in 'uDMImages.pas' {DMImages: TDataModule},
  uSpriteChampignon in 'uSpriteChampignon.pas',
  uSpriteMur in 'uSpriteMur.pas',
  uSpriteFleur in 'uSpriteFleur.pas',
  uSpritePiege in 'uSpritePiege.pas',
  uSpriteAraignee in 'uSpriteAraignee.pas',
  uSpriteJoueur in 'uSpriteJoueur.pas',
  uSpriteBonus in 'uSpriteBonus.pas',
  USpriteEnnemi in 'USpriteEnnemi.pas',
  uSpriteTir in 'uSpriteTir.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TDMImages, DMImages);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
