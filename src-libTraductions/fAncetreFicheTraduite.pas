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
  File last update : 2025-05-25T09:31:36.634+02:00
  Signature : 154eca8f0c0a9433ee7c0bc21a6ab10bd464d3b2
  ***************************************************************************
*)

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
