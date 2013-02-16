#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

function Main()

   local oForm1, oCbx1, cCbx1 := "two", oBtn1, oBtn2

   DEFINE WINDOW oForm1 TITLE "Form1" ;
      SIZE 482, 246

   @  30, 171 COMBOBOX oCbx1 VAR cCbx1 ITEMS { "one", "two", "three" } ;
      SIZE 120, 120 PIXEL OF oForm1

   @ 190, 134 BUTTON oBtn1 PROMPT "Button" ;
      SIZE 80, 30 PIXEL OF oForm1 ;
      ACTION oCbx1:SetText( "yes" )

   @ 189, 268 BUTTON oBtn2 PROMPT "Button" ;
      SIZE 80, 30 PIXEL OF oForm1 ;
      ACTION MsgInfo( "Not defined yet!" )

   ACTIVATE WINDOW oForm1 CENTERED

return oForm1

//----------------------------------------------------------------------------//
