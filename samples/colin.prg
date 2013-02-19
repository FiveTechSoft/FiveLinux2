#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

function Main()

   local oForm1, oGet1, cGet1 := "hello", oGet2, cGet2 := "world", oGet3, cGet3 := Space( 20 ), oBtn1, oBtn2

   DEFINE DIALOG oForm1 TITLE "Form1" ;
      SIZE 522, 314

   @  91, 111 GET oGet1 VAR cGet1 SIZE 200,  29 PIXEL OF oForm1

   @ 127, 113 GET oGet2 VAR cGet2 SIZE 200,  29 PIXEL OF oForm1

   @ 162, 114 GET oGet3 VAR cGet3 SIZE 200,  24 PIXEL OF oForm1

   @ 251, 174 BUTTON oBtn1 PROMPT "Button" ;
      SIZE 80, 30 PIXEL OF oForm1 ;
      ACTION ( oGet2:SetSel( 0, 0 ), oGet2:SetCurPos( 0 ) )

   @ 250, 277 BUTTON oBtn2 PROMPT "Button" ;
      SIZE 80, 30 PIXEL OF oForm1 ;
      ACTION oForm1:End()

   ACTIVATE DIALOG oForm1 CENTERED

return oForm1

//----------------------------------------------------------------------------//

