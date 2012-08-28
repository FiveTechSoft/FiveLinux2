#include "FiveLinux.ch"

function Main()

   local oWnd, oFld, cName := "Test   "

   DEFINE WINDOW oWnd TITLE "Testing folders"

   @ 2, 2 FOLDER oFld PROMPTS "_One", "_Two", "T_hree" OF oWnd

   @ 6, 3 SAY "Name:" OF oFld:aDialogs[ 1 ]

   @ 6, 9 GET cName OF oFld:aDialogs[ 1 ]

   @ 24, 2 IMAGE FILENAME "flh.gif" OF oWnd

   @ 24, 25 BUTTON "_Ok" OF oWnd ACTION MsgInfo( cName )

   ACTIVATE WINDOW oWnd

return nil