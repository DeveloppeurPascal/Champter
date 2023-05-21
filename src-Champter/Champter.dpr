program Champter;

uses
  System.StartUpCopy,
  FMX.Forms,
  fAncetreCadreTraduit
    in '..\src-libTraductions\fAncetreCadreTraduit.pas' {_AncetreCadreTraduit: TFrame} ,
  fAncetreFicheTraduite
    in '..\src-libTraductions\fAncetreFicheTraduite.pas' {_AncetreFicheTraduite} ,
  uDMTraductions
    in '..\src-libTraductions\uDMTraductions.pas' {dmTraductions: TDataModule} ,
  fMain in 'fMain.pas' {frmMain} ,
  Champter.Types in 'Champter.Types.pas',
  Champter.Consts in 'Champter.Consts.pas',
  cDessinNiveau in 'cDessinNiveau.pas' {zoneDessinNiveau: TFrame} ,
  uPartieEnCours in 'uPartieEnCours.pas',
  uSprite in 'uSprite.pas',
  uDMImages in 'uDMImages.pas' {DMImages: TDataModule} ,
  uSpriteChampignon in 'uSpriteChampignon.pas',
  uSpriteMur in 'uSpriteMur.pas',
  uSpriteFleur in 'uSpriteFleur.pas',
  uSpritePiege in 'uSpritePiege.pas',
  uSpriteAraignee in 'uSpriteAraignee.pas',
  uSpriteJoueur in 'uSpriteJoueur.pas',
  uSpriteBonus in 'uSpriteBonus.pas',
  USpriteEnnemi in 'USpriteEnnemi.pas',
  uSpriteTir in 'uSpriteTir.pas',
  Gamolf.FMX.Joystick
    in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.Joystick.pas',
  Gamolf.FMX.MusicLoop
    in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.MusicLoop.pas',
  Gamolf.RTL.Joystick.DirectInput.Win
    in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.DirectInput.Win.pas',
  Gamolf.RTL.Joystick.Mac
    in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.Mac.pas',
  Gamolf.RTL.Joystick
    in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.pas',
  Gamolf.RTL.Scores
    in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Scores.pas',
  iOSapi.GameController
    in '..\lib-externes\Delphi-Game-Engine\src\iOSapi.GameController.pas',
  Macapi.GameController
    in '..\lib-externes\Delphi-Game-Engine\src\Macapi.GameController.pas',
  JoystickManager in 'JoystickManager.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Landscape,
    TFormOrientation.InvertedLandscape];
  Application.CreateForm(TDMImages, DMImages);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
