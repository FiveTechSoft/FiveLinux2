// Starting a forms designer

#include "FiveLinux.ch"

function Main()

   local oWnd

   DEFINE WINDOW oWnd

   @ 2, 2 BUTTON "Button" OF oWnd DESIGN ;
      ACTION MsgInfo( "click" )

   @ 6, 2 BUTTON "Button" OF oWnd DESIGN ;
      ACTION MsgInfo( "click" )

   ACTIVATE WINDOW oWnd CENTER

return nil
