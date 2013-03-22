#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

function Main()

   local oDlg, oSay1, oGet1, cGet1 := Space( 20 ), oSay2, oFld1, oSay3, oBtn1, oBtn2, oBtn3, oBtn4
   local oResult, cResult := ""

   DEFINE DIALOG oDlg TITLE "Visual Make for Harbour" ;
      SIZE 557, 500

   @  20,  20 SAY oSay1 PROMPT "Main PRG" SIZE  80,  20 PIXEL OF oDlg

   @  41,  20 GET oGet1 VAR cGet1 SIZE 262,  26 PIXEL OF oDlg

   @  86,  20 SAY oSay2 PROMPT "Additional" SIZE  80,  20 PIXEL OF oDlg

   @ 108, 20 FOLDER oFld1 PROMPTS "PRGs", "Cs", "OBJs", "LIBs", "HBCs" ;
      SIZE 363, 204 PIXEL OF oDlg

   @ 328,  13 SAY oSay3 PROMPT "Result" SIZE  80,  20 PIXEL OF oDlg

   @ 347,  20 GET oResult VAR cResult MEMO SIZE 363, 144 OF oDlg PIXEL

   @ 31, 412 BUTTON oBtn2 PROMPT "_Build" ;
      SIZE 123, 50 PIXEL OF oDlg ;
      ACTION MsgInfo( "Not defined yet!" )

   @ 87, 412 BUTTON oBtn3 PROMPT "_Settings" ;
      SIZE 124, 50 PIXEL OF oDlg ;
      ACTION MsgInfo( "Not defined yet!" )

   @ 143, 412 BUTTON oBtn4 PROMPT "_Exit" ;
      SIZE 124, 50 PIXEL OF oDlg ;
      ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return oDlg

//----------------------------------------------------------------------------//
