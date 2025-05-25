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
  File last update : 2025-05-25T09:31:36.614+02:00
  Signature : d3c9b5117a0793226ac1efa8731a29a3a517bc21
  ***************************************************************************
*)

unit Champter.Consts;

interface

const
  /// <summary>
  /// N° du bit de l'élément dans chaque case du tableau du niveau de jeu
  /// </summary>
  cHasAraignee = 1;
  cHasChampignon = 2;
  cHasFleur = 4;
  cHasJoueur = 8;
  cHasEnnemi = 16;
  cHasMur = 32;
  cHasPiege = 64;
  cHasTir = 128;

  /// <summary>
  /// Signature des fichiers de tableaux de jeux
  /// </summary>
  c_copter_data_disk_GameCPTR =
    #8'COPTER Data Disk ##'#10#13'(c) Olf Software'#10#13 +
    'all rights reserved for all world'#10#13#26#0;
  c_copter_data_disk_Champter =
    #8'CHAMPTER Data Disk ##'#10#13'(c) Gamolf / Olf Software'#10#13 +
    'all rights reserved'#10#13#26#0;

  /// <summary>
  /// Valeurs d'initialisation d'une partie
  /// </summary>
  cInitNbVies = 5;
  cInitNbBombes = 5;
  cInitChrono = 24 * 8 * 10; // TODO : gérer le chrono

  /// <summary>
  /// Taille d'une case de jeu en pixels
  /// </summary>
  cNbPixelsParCase = 48;

  /// <summary>
  /// Points attribués au joueur lors de ces actions
  /// </summary>
  cScoreAraigneeTuee = 75;
  cScoreEnnemiDetruit = 100;
  cScoreChampignonRamasse = 3;
  cScoreFleurDetruite = 10;
  cScoreMurDetruit = 7;
  cScoreViesRestantes = 10;
  cScoreBombesRestantes = 25;
  cScoreTempsRestant = 2;
  cScoreBonusNiveauTermine = 33;
  cScoreBonusBombeRamassee = 30;
  cScoreBonusTempsRamasse = 50;
  cScoreBonusVieRamassee = 65;

implementation

end.
