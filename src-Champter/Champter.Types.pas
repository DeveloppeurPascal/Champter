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
  Signature : e3acf264c5879bd5498a7f82337e28035196ae12
  ***************************************************************************
*)

unit Champter.Types;

interface

uses
  System.Generics.Collections;

type
  TCase = word;
  TColonne = TList<TCase>;
  TGrille = TObjectList<TColonne>;

  /// <summary>
  /// Niveau de jeu
  /// </summary>
  TNiveau = class
  private
    FGrille: TGrille;
    procedure SetGrille(const Value: TGrille);
    function GetNbCol: integer;
    function GetNbLig: integer;
  public
    property NbCol: integer read GetNbCol;
    property NbLig: integer read GetNbLig;
    property Grille: TGrille read FGrille write SetGrille;
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  /// <summary>
  /// Liste de niveau de jeu
  /// </summary>
  TNiveauList = TObjectList<TNiveau>;

  /// <summary>
  /// Regroupement de tableaux de jeu
  /// ("data disk" dans Copter (GAMECPTR) de 1992)
  /// </summary>
  TGroupeDeNiveaux = class
  private
    FNomDeFichier: string;
    FListeDeNiveaux: TNiveauList;
    procedure SetNomDeFichier(const Value: string);
    procedure SetListeDeNiveaux(const Value: TNiveauList);
  public
    property ListeDeNiveaux: TNiveauList read FListeDeNiveaux
      write SetListeDeNiveaux;
    property NomDeFichier: string read FNomDeFichier write SetNomDeFichier;
    procedure LoadFromFile(ANomDeFichier: string = '');
    procedure SaveToFile(ANomDeFichier: string = '');
    procedure Initialise;
    constructor Create; virtual;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils, uDMTraductions;

{ TGroupeDeNiveaux }

constructor TGroupeDeNiveaux.Create;
begin
  FListeDeNiveaux := TNiveauList.Create;
end;

destructor TGroupeDeNiveaux.Destroy;
begin
  if FListeDeNiveaux <> nil then
    FListeDeNiveaux.Free;
  inherited;
end;

procedure TGroupeDeNiveaux.Initialise;
begin
  ListeDeNiveaux.Clear;
end;

procedure TGroupeDeNiveaux.LoadFromFile(ANomDeFichier: string);
type
  t_tab = array [1 .. 40, 1 .. 20] of byte;
  t_data = array [1 .. 16] of t_tab;
  t_tempo_tir = word;
var
  f: file;
  ch: array [0 .. 255] of byte;
  // (string de Pascal avant Delphi 2009 = AnsiString)
  num_data_disk: byte;
  data_disk: t_data;
  NumTab, Col, Lig: integer;
  Niveau: TNiveau;
  Colonne: TColonne;
begin
  if not ANomDeFichier.isempty then
    NomDeFichier := ANomDeFichier;

  if NomDeFichier.isempty then
    raise exception.Create(_('FilenameEmptyError', 'Nom de fichier inconnu.'));
  // TODO : traduire texte

  Initialise;

  assignfile(f, NomDeFichier);
  try
    filemode := fmOpenRead;
    reset(f, 1);
    try
      // Chargement de la chaine de signature du fichier
      blockread(f, ch[0], 1);
      if (ch[0] > 0) then
      begin
        blockread(f, ch[1], ch[0]);
        if (ch[3] = ord('O')) then // Format GAMECPTR / Copter de 1992
        begin
          blockread(f, num_data_disk, sizeof(num_data_disk));
          blockread(f, data_disk, sizeof(data_disk));
          for NumTab := 1 to 16 do
          begin
            Niveau := TNiveau.Create;
            for Lig := 1 to 20 do
            begin
              Colonne := TColonne.Create;
              for Col := 1 to 40 do
                Colonne.Add(data_disk[NumTab][Col, Lig]);
              Niveau.Grille.Add(Colonne);
            end;
            ListeDeNiveaux.Add(Niveau);
          end;
          // On ignore la fin du format de stockage d'origine :
          // les délais d'affichages / masquage des tirs sont calculés
          // automatiquement en fonction de leur taille dans Champter
          // contrairement à ce qui se faisait dans Copter
          // setlength(tir_tab, 0);
          // if not eof(f) then
          // begin
          // blockread(f, nb_tir, sizeof(nb_tir));
          // setlength(tir_tab, nb_tir);
          // blockread(f, tir_tab[0], nb_tir * sizeof(t_tempo_tir));
          // end;
        end
        else if (ch[3] = ord('H')) then // Format Champter de 2021
        begin
          // TODO : gérer le nouveau format de stockage
        end
        else
          raise exception.Create(_('UnknowFormatError', 'Format non reconnu.'));
        // TODO : traduire texte
      end
      else
        raise exception.Create(_('UnknowFormatError', 'Format non reconnu.'));
      // TODO : traduire texte
    finally
      close(f);
    end;
  except
    raise exception.Create(_('LoadDataDiskError',
      'Chargement du fichier impossible.'));
    // TODO : traduire texte
  end;
end;

procedure TGroupeDeNiveaux.SaveToFile(ANomDeFichier: string);
begin
  if not ANomDeFichier.isempty then
    NomDeFichier := ANomDeFichier;

  if NomDeFichier.isempty then
    raise exception.Create(_('FilenameEmptyError', 'Nom de fichier inconnu.'));
  // TODO : traduire texte

  // TODO : à compléter
end;

procedure TGroupeDeNiveaux.SetListeDeNiveaux(const Value: TNiveauList);
begin
  FListeDeNiveaux := TNiveauList.Create;
end;

procedure TGroupeDeNiveaux.SetNomDeFichier(const Value: string);
begin
  FNomDeFichier := Value;
end;

{ TNiveau }

constructor TNiveau.Create;
begin
  FGrille := TGrille.Create;
end;

destructor TNiveau.Destroy;
begin
  if FGrille <> nil then
    FGrille.Free;
  inherited;
end;

function TNiveau.GetNbCol: integer;
begin
  if assigned(FGrille) then
    result := FGrille[0].Count
  else
    result := 0;
end;

function TNiveau.GetNbLig: integer;
begin
  if assigned(FGrille) then
    result := FGrille.Count
  else
    result := 0;
end;

procedure TNiveau.SetGrille(const Value: TGrille);
begin
  FGrille := Value;
end;

end.
