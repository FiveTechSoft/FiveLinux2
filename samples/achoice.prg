// Using ListBoxes to perform simple selections

#include "FiveLinux.ch"

//----------------------------------------------------------------//

function Main()

   MsgInfo( MsgSelect( { "one", "two", "three" }, "two" ) )

return nil

//----------------------------------------------------------------//

function MsgSelect( aItems, cValue, cTitle )

   local oDlg

   DEFAULT cTitle := "Please, select"

   DEFINE DIALOG oDlg TITLE cTitle SIZE 220, 150

   @  1, 2 LISTBOX cValue ITEMS aItems SIZE 180, 95 OF oDlg

   @ 12, 2 BUTTON "_OK" OF oDlg SIZE 80, 25 ;
     ACTION oDlg:End()

   @ 12, 12 BUTTON "_Cancel" OF oDlg SIZE 80, 25 ;
     ACTION ( cValue := nil, oDlg:End() )

   ACTIVATE DIALOG oDlg CENTERED

return cValue

//----------------------------------------------------------------//
