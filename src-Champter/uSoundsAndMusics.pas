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
  Signature : 272bfb572d06b3d9934e0820f6bcbb2ed0a1c23a
  ***************************************************************************
*)

unit uSoundsAndMusics;

interface

type
{$SCOPEDENUMS ON}
  TGameSounds = (none, KilledByTrap, KilledByLaser, KilledBySpaceship, WinLevel,
    UIButtonClick, TrapShow, KilledByFlower, WinGame, LaserShow, KilledBySpider,
    GameOver);
  TGameMusics = (none, Song_Exploration_02_Loop);

  /// <summary>
  /// play a sound
  /// </summary>
procedure PlaySound(Sound: TGameSounds);

/// <summary>
/// Stop all sounds
/// </summary>
procedure MuteSounds;

/// <summary>
/// Play a music loop
/// </summary>
procedure PlayMusic(Music: TGameMusics);

/// <summary>
/// Stop the current music loop
/// </summary>
procedure StopMusic;

implementation

uses
  Gamolf.FMX.MusicLoop, System.Classes, System.SyncObjs, System.SysUtils,
  System.IOUtils;

var
  MusicPlayer: TMusicLoop;
  SoundsPlayer: TSoundList;
  SoundsLoaded: TEvent;

type
  TSoundsFolder = (EpicStockMedia16Bits, GameDevMarketChildren);

function getSoundsFolder(SoundsFolder: TSoundsFolder): string;
begin
{$IF defined(ANDROID)}
  // deploy in .\assets\internal\
  result := tpath.GetDocumentsPath;
{$ELSEIF defined(MSWINDOWS)}
  // deploy in .\
{$IFDEF DEBUG}
  case SoundsFolder of
    TSoundsFolder.EpicStockMedia16Bits:
      result := '..\..\..\assets\EpicStockMedia_com\MobileGame16Bits';
    TSoundsFolder.GameDevMarketChildren:
      result := '..\..\..\assets\GamDevMarket_com-HumbleBundle-20220901\Children_Game_Music';
  else
    raise exception.Create('Unknow TSoundsFolder(' + ord(SoundsFolder).tostring
      + ') path.');
  end;
{$ELSE}
  result := extractfilepath(paramstr(0));
{$ENDIF}
{$ELSEIF defined(IOS)}
  // deploy in .\
  result := extractfilepath(paramstr(0));
{$ELSEIF defined(MACOS)}
  // deploy in Contents\MacOS
  result := extractfilepath(paramstr(0));
{$ELSEIF Defined(LINUX)}
  result := extractfilepath(paramstr(0));
{$ELSE}
{$MESSAGE FATAL 'OS non supporté'}
{$ENDIF}
end;

procedure PlaySound(Sound: TGameSounds);
begin
  if (SoundsLoaded.waitfor(INFiNItE) <> twaitresult.wrsignaled) then
    raise exception.Create('Sounds library not loaded.');
  // TODO : tester si son ON/OFF et si OK, jouer le son

  if Sound <> TGameSounds.none then
    SoundsPlayer.Play(ord(Sound));
end;

procedure MuteSounds;
begin
  if (SoundsLoaded.waitfor(INFiNItE) <> twaitresult.wrsignaled) then
    raise exception.Create('Sounds library not loaded.');

  SoundsPlayer.MuteAll;
end;

procedure PlayMusic(Music: TGameMusics);
var
  FileName: string;
begin
  // TODO : tester si son ON/OFF et si OK, jouer le son

  if Music = TGameMusics.none then
    MusicPlayer.Stop
  else
  begin
    case Music of
      TGameMusics.Song_Exploration_02_Loop:
        FileName := 'Song_Exploration_02_Loop.wav';
    else
      raise exception.Create('Music n°' + ord(Music).tostring + ' unknown.');
    end;
    MusicPlayer.Play
      (tpath.Combine(getSoundsFolder(TSoundsFolder.GameDevMarketChildren),
      FileName));
  end;
end;

procedure StopMusic;
begin
  MusicPlayer.Stop;
end;

procedure initMusics;
begin
  MusicPlayer := TMusicLoop.Create;
  // TODO : charger paramètre musique ON/OFF
  // TODO : charger paramètre volume musique
end;

procedure LoadGameSounds;
var
  SoundID: TGameSounds;
  FileName: string;
begin
  for SoundID := low(TGameSounds) to high(TGameSounds) do
  begin
    if SoundID = TGameSounds.none then
      continue;
    case SoundID of
      TGameSounds.KilledByTrap:
        FileName := 'ActionMorph1.wav';
      TGameSounds.KilledByLaser:
        FileName := 'ActionMorph3.wav';
      TGameSounds.KilledBySpaceship:
        FileName := 'ExplosionPowerUp2.wav';
      TGameSounds.WinLevel:
        FileName := 'IslandLevelComplete1.wav';
      TGameSounds.UIButtonClick:
        FileName := 'JugUnplugButton1.wav';
      TGameSounds.TrapShow:
        FileName := 'MachineryUpgrade1.wav';
      TGameSounds.KilledByFlower:
        FileName := 'MilitaryHornLoss1.wav';
      TGameSounds.WinGame:
        FileName := 'MilitaryLevelComplete3.wav';
      TGameSounds.LaserShow:
        FileName := 'MagicalGlassBurst2.wav';
      TGameSounds.KilledBySpider:
        FileName := 'UnderwaterPowerUp1.wav';
      TGameSounds.GameOver:
        FileName := 'WoodlandLoss1.wav';
    else
      raise exception.Create('Sound n°' + ord(SoundID).tostring + ' unknown.');
    end;
    SoundsPlayer.Add(ord(SoundID),
      tpath.Combine(getSoundsFolder(TSoundsFolder.EpicStockMedia16Bits),
      FileName));
  end;
end;

procedure initSounds;
begin
  SoundsPlayer := TSoundList.Create;
  // TODO : charger paramètre son ON/OFF
  // TODO : charger paramètre volume son

  tthread.createanonymousthread(
    procedure
    begin
      try
        try
          LoadGameSounds;
        except
          // TODO : désactiver la musique d'ambiance et les bruitages car non chargés en mémoire
        end;
      finally
        SoundsLoaded.setevent;
      end;
    end).start;
end;

initialization

initMusics;

SoundsLoaded := TEvent.Create;
SoundsLoaded.resetevent;

initSounds;

finalization

SoundsLoaded.free;
SoundsPlayer.free;
MusicPlayer.free;

end.
