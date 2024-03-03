#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Shane Koehler

 Script Function:
	Strips all special chars and sets proper formatting on CIDs with dots

	supports 12.AAAA.123456..BBBB and 12.AAAA.123456.BBB.CCCC

#ce ----------------------------------------------------------------------------

#include <Array.au3>

#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>

#include <Clipboard.au3>
#include <String.au3>

Opt("GUIOnEventMode", 1)

Global $hGui, $hEdit, $hCheckbox, $hButtonRun, $hButtonCopy

_gui_create();

Func _gui_create()

	$hGui = GUICreate("SlashDot", 400, 600)
	$hEdit = GUICtrlCreateEdit("", 0, 0, 400, 560, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_MULTILINE + $ES_WANTRETURN)
	;$hCheckbox = GUICtrlCreateCheckbox("Strip nonsense", 30, 570, 120, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$hButtonCopy = GUICtrlCreateButton("Copy", 230, 570, 60, 20)
	$hButtonRun = GUICtrlCreateButton("Run", 310, 570, 60, 20)

	GUISetOnEvent($GUI_EVENT_CLOSE, "_gui_close")
	GUICtrlSetOnEvent($hButtonRun, "_gui_buttonRun")
	GUICtrlSetOnEvent($hButtonCopy, "_gui_buttonCopy")

	GUISetState(@SW_SHOW, $hGui)

	While 1
		Sleep(10)
	WEnd

EndFunc

Func _gui_close()
	GUIDelete($hGui)
	Exit
EndFunc

Func _gui_buttonCopy()
	_ClipBoard_SetData( GUICtrlRead($hEdit) )
EndFunc

Func _gui_buttonRun()
	Local $newData = "";
	Local $discard = true;(GUICtrlRead($hCheckbox) = $GUI_CHECKED)
	Local $data = GUICtrlRead($hEdit);
	Local $split = StringSplit($data, @CRLF);

	For $x = 1 To $split[0] Step 1

		Local $curData = $split[$x];
		If NOT $curData Then ContinueLoop;

	    Local $aTest = StringRegExp($curData, "\d{2}\.[a-zA-Z0-9]{4}\.\d{6}(\.\.|\.[a-zA-Z0-9]{3}\.)(TWCC|CHTR)", 2); 31.L2XX.000003.LXM.TWCC
		If @error Then ContinueLoop;

		$newData &= $aTest[0] & @CRLF;

	Next

	GUICtrlSetData($hEdit, $newData)
EndFunc

; OLD
#cs
		Local $stripped = StringRegExpReplace($curData,"[^0-9a-zA-Z\s]","");

		; attempt to split by space
		Local $splitLine = StringSplit($stripped, " ");
		Local $newLine = ""

		For $y = 1 To $splitLine[0] Step 1
			Local $curDataLine = $splitLine[$y];
			If NOT $curDataLine Then ContinueLoop;

			Switch StringLen($curDataLine)
				Case 16 ; format should be 12.AAAA.123456..BBBB
					$curDataLine = _StringInsert($curDataLine, "..", 12);
					$curDataLine = _StringInsert($curDataLine, ".", 6);
					$curDataLine = _StringInsert($curDataLine, ".", 2);

				Case 19 ; format should be 12.AAAA.123456.BBB.CCCC
					$curDataLine = _StringInsert($curDataLine, ".", 15);
					$curDataLine = _StringInsert($curDataLine, ".", 12);
					$curDataLine = _StringInsert($curDataLine, ".", 6);
					$curDataLine = _StringInsert($curDataLine, ".", 2);

				;Case 22
					; 81ATTM10043801TE002BHN
					; IDK

				;72L1XX800232TWCC1193

				Case Else
					$curDataLine = "??? "&$curDataLine&" ???";
			EndSwitch

			; do something with $curDataLine
			If NOT $discard Then
				If $y > 0 Then $newLine &= " - "
				$newLine &= $curDataLine
			ElseIf $curDataLine <> $splitLine[$y] Then
				$newLine = $curDataLine
			EndIf
		Next

		$newData &= $newLine & @CRLF;
		#ce
;~ Local $newData = "";
;~ Local $data = _ClipBoard_GetData();
;~ Local $split = StringSplit($data, @CRLF);

;~ For $x = 1 To $split[0] Step 1

;~ 	Local $curData = $split[$x];
;~ 	If NOT $curData Then ContinueLoop;

;~ 	Local $stripped = StringRegExpReplace($curData,"[^0-9a-zA-Z\s]","");

;~ 	; attempt to split by space?  just screw it and make gui?

;~ 	Switch StringLen($stripped)
;~ 		Case 16 ; format should be 12.AAAA.123456..BBBB
;~ 			$stripped = _StringInsert($stripped, "..", 12);
;~ 			$stripped = _StringInsert($stripped, ".", 6);
;~ 			$stripped = _StringInsert($stripped, ".", 2);

;~ 		Case 19 ; format should be 12.AAAA.123456.BBB.CCCC
;~ 			$stripped = _StringInsert($stripped, ".", 15);
;~ 			$stripped = _StringInsert($stripped, ".", 12);
;~ 			$stripped = _StringInsert($stripped, ".", 6);
;~ 			$stripped = _StringInsert($stripped, ".", 2);

;~ 		Case Else
;~ 			; do nothing
;~ 	EndSwitch

;~ 	$newData &= $stripped & @CR;

;~ Next

;~ _ClipBoard_SetData($newData);

; DOUBLE OLD
;~ Local $replaced = StringReplace($data, "/", ".");
;~ _ClipBoard_SetData($replaced);

