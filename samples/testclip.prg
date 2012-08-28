// Testing the clipboard

#include "FiveLinux.ch"

function Main()

   local oWnd, cText := "hello   ", oClipboard

   DEFINE WINDOW oWnd TITLE "Testing the clipboard"

   DEFINE CLIPBOARD oClipboard

   @ 2, 2 GET cText OF oWnd

   @ 5, 2 SAY "right click on the get and copy some text" OF oWnd ;
      SIZE 240, 20

   @ 10, 2 BUTTON "Show Clipboard text" OF oWnd SIZE 150, 25 ;
      ACTION MsgInfo( oClipboard:GetText() )

   @ 10, 20 BUTTON "Set Clipboard text" OF oWnd SIZE 150, 25 ;
      ACTION oClipboard:SetText( "new text" )

   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Do you want to exit ?" )

return nil
