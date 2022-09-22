#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Shane Koehler

 Script Function:
	Strips all special chars and sets proper formatting on CIDs with dots

	supports 12.AAAA.123456..BBBB and 12.AAAA.123456.BBB.CCCC

#ce ----------------------------------------------------------------------------

#include <Clipboard.au3>
#include <String.au3>

Local $newData = "";
Local $data = _ClipBoard_GetData();
Local $split = StringSplit($data, @CRLF)

For $x = 1 To $split[0] Step 1

	Local $curData = $split[$x];
	If NOT $curData Then ContinueLoop;
	
	Local $stripped = StringRegExpReplace($curData,"[^0-9a-zA-Z\s]","")

	Switch StringLen($stripped)
		Case 16 ; format should be 12.AAAA.123456..BBBB
			$stripped = _StringInsert($stripped, "..", 12);
			$stripped = _StringInsert($stripped, ".", 6);
			$stripped = _StringInsert($stripped, ".", 2);

		Case 19 ; format should be 12.AAAA.123456.BBB.CCCC
			$stripped = _StringInsert($stripped, ".", 15);
			$stripped = _StringInsert($stripped, ".", 12);
			$stripped = _StringInsert($stripped, ".", 6);
			$stripped = _StringInsert($stripped, ".", 2);

		Case Else
			; do nothing
	EndSwitch

	$newData &= $stripped & @CR;

Next

_ClipBoard_SetData($newData);

; OLD
;~ Local $replaced = StringReplace($data, "/", ".");
;~ _ClipBoard_SetData($replaced);

