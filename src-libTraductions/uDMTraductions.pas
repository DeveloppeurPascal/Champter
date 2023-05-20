unit uDMTraductions;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.StorageBin, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  FireDAC.Phys.SQLiteVDataSet, {$IFDEF MSWINDOWS}FireDAC.VCLUI.Wait, {$ENDIF}FMX.Forms;

type
  TdmTraductions = class(TDataModule)
    tabTextesTraduits: TFDMemTable;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function _(id, DefaultText: string): string;
function ChangeLangue(Langue: string): boolean;
function GetLangue: string;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

uses
  System.IOUtils, fAncetreFicheTraduite;

var
  LangueSelectionnee: string;

var
  _DMTraductions: TdmTraductions;

function DMTraductions: TdmTraductions;
begin
  if not assigned(_DMTraductions) then
    _DMTraductions := TdmTraductions.Create(Application);
  result := _DMTraductions;
end;

procedure TdmTraductions.DataModuleCreate(Sender: TObject);
var
  NomFichier: string;
begin
{$IF Defined(MSWINDOWS)}
{$IFDEF DEBUG}
  NomFichier := tpath.Combine(tpath.GetDirectoryName(paramstr(0)),
    '..\..\..\colblor.bin');
{$ELSE}
  NomFichier := tpath.Combine(tpath.GetDirectoryName(paramstr(0)),
    'colblor.bin');
{$ENDIF}
{$ELSEIF Defined(ANDROID)}
  // .\assets\internal\
  NomFichier := tpath.Combine(tpath.GetDocumentsPath, 'colblor.bin');
{$ELSEIF defined(IOS)}
  // deploy in .\
  NomFichier := tpath.Combine(tpath.GetDirectoryName(paramstr(0)),
    'colblor.bin');
{$ELSEIF defined(MACOS)}
  // deploy in Contents\MacOS
  NomFichier := tpath.Combine(tpath.GetDirectoryName(paramstr(0)),
    'colblor.bin');
{$ELSEIF Defined(LINUX)}
  NomFichier := tpath.Combine(tpath.GetDirectoryName(paramstr(0)),
    'colblor.bin');
{$ELSE}
{$MESSAGE FATAL 'OS non supporté'}
{$ENDIF}
  if tfile.Exists(NomFichier) then
    tabTextesTraduits.LoadFromFile(NomFichier);
  // TODO : Ajouter les chemins liés aux différentes plateformes (notamment mobiles)
end;

function _(id, DefaultText: string): string;
begin
  result := '';
  try // TODO : comprendre pourquoi ce bloc génère une violation d'accès lorsqu'utilisé depuis l'IDE dans un composant
    try
      if DMTraductions.tabTextesTraduits.Active then
        if DMTraductions.tabTextesTraduits.Locate('id', id) then
          result := DMTraductions.tabTextesTraduits.fieldbyname
            (LangueSelectionnee).AsString;
    finally
      if result.IsEmpty then
        result := DefaultText;
    end;
  except
  end;
end;

function ChangeLangue(Langue: string): boolean;
var
  i: integer;
begin
  result := DMTraductions.tabTextesTraduits.Active and
    assigned(DMTraductions.tabTextesTraduits.Fields.fieldbyname(Langue));
  if result then
  begin
    LangueSelectionnee := Langue;
    for i := 0 to Screen.FormCount - 1 do
      if (Screen.Forms[i] is T_AncetreFicheTraduite) then
        (Screen.Forms[i] as T_AncetreFicheTraduite).TraduireTextes;
  end;
end;

function GetLangue: string;
begin
  result := LangueSelectionnee;
end;

initialization

LangueSelectionnee := 'fr';
// TODO : récupérer langue par défaut du système d'exploitation
_DMTraductions := nil;

end.
