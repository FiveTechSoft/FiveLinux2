#include "FiveLinux.ch"

static oWnd

function Main()

   local lVal := .t., cName := "Hello", cItem, cLbx, nVal := 100, oBar

   DEFINE WINDOW oWnd TITLE "Testing controls" ;
      MENU BuildMenu()

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON OF oBar RESOURCE "gtk-new" ACTION MsgInfo( "New" )

   DEFINE BUTTON OF oBar RESOURCE "gtk-open" ACTION MsgInfo( "Open" )

   DEFINE BUTTON OF oBar RESOURCE "gtk-save" ;
      ACTION MsgInfo( "Save" ) GROUP

   DEFINE BUTTON OF oBar RESOURCE "gtk-quit" ACTION oWnd:End()

   @ 9,  1 SAY "A Say" OF oWnd

   @ 12, 2 CHECKBOX lVal PROMPT "Click me" OF oWnd

   @ 15, 2 GET cName OF oWnd

   @ 18, 2 COMBOBOX cItem OF oWnd ITEMS { "one", "two", "three" }

   @ 9, 22 LISTBOX cLbx OF oWnd ;
      ITEMS { "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve" }

   @ 21, 2 METER nVal TOTAL 200 OF oWnd

   @ 24, 2 IMAGE FILENAME "flh.gif" OF oWnd

   @ 26, 30 BUTTON "" OF oWnd ACTION MsgInfo( cLbx ) RESOURCE "gtk-ok"

   @ 26, 39 BUTTON "" OF oWnd ACTION MsgInfo( cItem ) RESOURCE "gtk-cancel"

   SET MSGBAR OF oWnd TO " FiveLinux - (c) FiveTech Software 2004"

   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Are you sure ?" ) ;
      ON RIGHT CLICK MsgInfo( "right click" )

return nil

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM "One"
      MENU
         MENUITEM "First"  RESOURCE "gtk-new"  ACTION MsgInfo( "New" )
	 MENU
	    MENUITEM "One"
	    MENUITEM "Two"
	    SEPARATOR
	    MENUITEM "Three"
	 ENDMENU
	 MENUITEM "Second" RESOURCE "gtk-quit" ACTION oWnd:End()
      ENDMENU

      MENUITEM "Two"     ACTION MsgInfo( "Two" )
      MENUITEM "Three"   ACTION MsgInfo( "Three" )
   ENDMENU

return oMenu
