#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Shane Koehler

 Script Function:
	Change any instance of / to . in the clipboard

#ce ----------------------------------------------------------------------------

#include <Clipboard.au3>
Local $data = _ClipBoard_GetData();
Local $replaced = StringReplace($data, "/", ".");
_ClipBoard_SetData($replaced);