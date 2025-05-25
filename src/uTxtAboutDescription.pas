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
  File last update : 2025-05-25T19:27:18.000+02:00
  Signature : 6bbe94eb72aaeefa78de2615e007816c73a02fa5
  ***************************************************************************
*)

unit uTxtAboutDescription;

interface

function GetTxtAboutDescription(const Language: string;
  const Recursif: boolean = false): string;

implementation

// For the languages codes, please use 2 letters ISO codes
// https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes

uses
  System.SysUtils,
  uConsts;

const
  CTxtEN = '''
Champter was developed during live coding sessions on Twitch with FireMonkey under Delphi.

You can play with the keyboard or a game controller depending on your device (computer, smartphone or tablet).

*****************
* Credits

This application was developed by Patrick Prémartin.

The background music is licensed by Game Dev Market (https://www.gamedevmarket.net).
The sound effects come from Collin Scudder and Martin Meinerz. They are licensed by Epic Stock Media (https://epicstockmedia.com).

Graphics from Kenney (https://kenney.nl), Patrick Prémartin, Adobe Stock.

The game has been developed in Delphi. It's based on Gamolf FMX Game Starter Kit and Delphi Game Engine to handle the classic functionalities (music, sounds, parameters, scores, screen sequencing and user interface interactivity).

*****************
* Publisher info

This video game is published by OLF SOFTWARE, a company registered in Paris (France) under the reference 439521725.

****************
* Personal data

This program is autonomous in its current version. It does not depend on the Internet and communicates nothing to the outside world.

We have no knowledge of what you do with it.

No information about you is transmitted to us or to any third party.

We use no cookies, no tracking, no stats on your use of the application.

***************
* User support

If you have any questions or require additional functionality, please leave us a message on the application's website or on its code repository.

To find out more, visit https://champter.gamolf.fr

''';
   CTxtFR = '''
Champter a été développé lors de sessions de codage en direct sur Twitch avec FireMonkey sous Delphi.

Vous pouvez y jouer avec le clavier ou un contrôleur de jeux selon votre appareil (ordinateur, smartphone ou tablette).

*****************
* Remerciements

Cette application a été développée par Patrick Prémartin.

La musique d'ambiance est sous licence de Game Dev Market (https://www.gamedevmarket.net).
Les effets sonores sont de  Collin Scudder et Martin Meinerz. Ils sont sous licence de Epic Stock Media (https://epicstockmedia.com).

Les graphismes sont de Kenney (https://kenney.nl), Patrick Prémartin et Adobe Stock.

Ce jeu est développé sous Delphi. Il est basé sur Gamolf FMX Game Starter Kit et Delphi Game Engine pour gérer les fonctionnalités classiques (musiques, sons, paramétres, scores, enchaînement des écrans et interctions avec l'interface utilisateur).

*****************
* Info éditeur

Ce jeu vidéo est éditée par OLF SOFTWARE, société enregistrée à Paris (France) sous la référence 439521725.

****************
* Données personnelles

Ce programme est autonome dans sa version actuelle. Il ne dépend pas d'Internet et ne communique rien au monde extérieur.

Nous n'avons aucune connaissance de ce que vous faites avec lui.

Aucune information vous concernant n'est transmise à nous ou à des tiers.

Nous n'utilisons pas de cookies, pas de tracking, pas de statistiques sur votre utilisation de l'application.

***************
* Assistance aux utilisateurs

Si vous avez des questions ou si vous avez besoin de fonctionnalités supplémentaires, veuillez nous laisser un message sur le site web de l'application ou sur son dépôt de code.

Pour en savoir plus, visitez https://champter.gamolf.fr

''';
  // CTxtIT = '';
  // CTxtDE = '';
  // CTxtJP = '';
  // CTxtPT = '';
  // CTxtES = '';

function GetTxtAboutDescription(const Language: string;
  const Recursif: boolean): string;
var
  lng: string;
begin
  lng := Language.tolower;
  if (lng = 'en') then
    result := CTxtEN
  else if (lng = 'fr') then // France
    result := CTxtFR
  else if not Recursif then
    result := GetTxtAboutDescription(CDefaultLanguage, true)
  else
    raise Exception.Create('Unknow description for language "' +
      Language + '".');
end;

end.
