#include "FiveLinux.ch"

function Main()

   local oDlg

   DEFINE DIALOG oDlg TITLE "Testing popup menus"

   @ 2, 2 SAY "right click" OF oDlg

   ACTIVATE DIALOG oDlg CENTERED ;
      VALID MsgYesNo( "Want to end ?" ) ;
      ON RIGHT CLICK ShowPopup( oDlg )

return nil

function ShowPopup( oDlg )

   local oPopup

   MENU oPopup POPUP
      MENUITEM "One"   RESOURCE "gtk-new"  ACTION MsgInfo( "new" )
      MENUITEM "Two"   RESOURCE "gtk-save" ACTION MsgInfo( "save" )
      MENUITEM "Three" RESOURCE "gtk-quit" ACTION MsgInfo( "quit" )
   ENDMENU

   ACTIVATE POPUP oPopup OF oDlg

return nil
