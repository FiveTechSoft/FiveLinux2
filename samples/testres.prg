#include "FiveLinux.ch"

function Main()

   local oDlg, oBtn1, oBtn2

   SET RESOURCES TO "./test.glade"

   DEFINE DIALOG oDlg RESOURCE "customer"

   REDEFINE BUTTON oBtn1 ID "button1" OF oDlg ACTION MsgInfo( "Click" )

   REDEFINE BUTTON oBtn2 ID "button2" OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED ;
      VALID MsgYesNo( "Want to end ?" )

return nil
