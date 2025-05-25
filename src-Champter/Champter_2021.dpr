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
  File last update : 2025-05-25T18:43:42.000+02:00
  Signature : 1da76bfe720a7c82d39b6cef82a608fbefbb5eae
  ***************************************************************************
*)

program Champter_2021;

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
  uSpriteTir in 'uSpriteTir.pas',
  Gamolf.FMX.Joystick in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.Joystick.pas',
  Gamolf.FMX.MusicLoop in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.MusicLoop.pas',
  Gamolf.RTL.Joystick.DirectInput.Win in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.DirectInput.Win.pas',
  Gamolf.RTL.Joystick.Mac in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.Mac.pas',
  Gamolf.RTL.Joystick in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.pas',
  Gamolf.RTL.Scores in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Scores.pas',
  iOSapi.GameController in '..\lib-externes\Delphi-Game-Engine\src\iOSapi.GameController.pas',
  Macapi.GameController in '..\lib-externes\Delphi-Game-Engine\src\Macapi.GameController.pas',
  JoystickManager in 'JoystickManager.pas',
  uSoundsAndMusics in 'uSoundsAndMusics.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Landscape,
    TFormOrientation.InvertedLandscape];
  Application.CreateForm(TDMImages, DMImages);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
