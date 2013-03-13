#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

function Main()

   local oForm1, oGet1, cGet1 := "hello", oGet2, cGet2 := "world", oGet3, cGet3 := Space( 20 ), oBtn1, oBtn2
   local oCbx1, cCbx1, aItems := { "one", "two", "three" }

   DEFINE DIALOG oForm1 TITLE "Form1" ;
      SIZE 522, 314

   @  91, 111 GET oGet1 VAR cGet1 SIZE 200,  29 PIXEL OF oForm1 UPDATE

   @ 127, 113 GET oGet2 VAR cGet2 SIZE 200,  29 PIXEL OF oForm1 UPDATE

   oGet2:bGotFocus = { || oGet2:SetText( Time() ), oGet2:SetCurPos( 0 ) }

   @ 197, 114 COMBOBOX oCbx1 VAR cCbx1 ITEMS aItems SIZE 200, 24 PIXEL OF oForm1 UPDATE

   @ 251, 174 BUTTON oBtn1 PROMPT "Clear" ;
      SIZE 80, 30 PIXEL OF oForm1 ;
      ACTION ( cGet1 := cGet2 := cGet3 := Space( 20 ), cCbx1 := "two", oForm1:Update(), oGet1:SetFocus() )

   @ 250, 277 BUTTON oBtn2 PROMPT "End" ;
      SIZE 80, 30 PIXEL OF oForm1 ;
      ACTION oForm1:End()

   ACTIVATE DIALOG oForm1 CENTERED

return oForm1

//----------------------------------------------------------------------------//

