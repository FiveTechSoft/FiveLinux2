#include "FiveLinux.ch"

function Main()

   local oWnd
   
   DEFINE WINDOW oWnd TITLE "Testing controls"
   
   @ 3, 2 BUTTON "OK" OF oWnd ACTION MsgAlert( "FiveLinux power!" )
   
   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Are you sure ?" )
      
return nil
   
   