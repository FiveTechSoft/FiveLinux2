#include "FiveLinux.ch"

function Main()

   local oWnd

   DEFINE WINDOW oWnd TITLE "Welcome to FiveLinux" ;
      MENU BuildMenu()

   @ 4, 2 BUTTON "OK" OF oWnd ACTION MsgInfo( "Welcome to Linux" )

   @ 8, 2 BUTTON "Hello" OF oWnd ACTION MsgAlert( "FiveLinux power!" )

   @ 12, 2 BUTTON "_Window" OF oWnd ACTION Another()

   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Want to end ?" )

return nil

function Another()

   local oWnd

   DEFINE WINDOW oWnd TITLE "Another window"

   ACTIVATE WINDOW oWnd VALID MsgYesNo( "sure ?" )

return nil

function BuildMenu()

   local oMenu

   MENU oMenu

      MENUITEM "_One"
      MENU
         MENUITEM "_First"         ACTION MsgInfo( "First action" )
	 MENUITEM "_Second"     ACTION MsgInfo( "Second action" )
	 MENU
	    MENUITEM "Another"
	    MENUITEM "More"       ACTION MsgInfo( "more action" )
	 ENDMENU
	 MENUITEM "Third"
      ENDMENU

      MENUITEM "Two"               ACTION MsgInfo( "two action" )
      MENUITEM "Three"

      MENUITEM "Four"
      MENU
         MENUITEM "One"            ACTION MsgInfo( "Four-One action" )
	 MENUITEM "Two"
      ENDMENU

   ENDMENU

return oMenu
