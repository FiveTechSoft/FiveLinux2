// Starting a forms designer

#include "FiveLinux.ch"

static oWndMain, oWnd, aWindows := {}, oIni

//----------------------------------------------------------------------------//

function Main()

   local oBar

   SET DATE FORMAT TO "DD/MM/YYYY"

   LoadPreferences()

   DEFINE WINDOW oWndMain TITLE "FiveForm" ;
      MENU BuildMenu()

   DEFINE BUTTONBAR oBar OF oWndMain

   DEFINE BUTTON OF oBar PROMPT "New" RESOURCE "gtk-new" ;
      ACTION New()

   DEFINE BUTTON OF oBar PROMPT "Open" RESOURCE "gtk-open" ;
      ACTION Open()

   DEFINE BUTTON OF oBar PROMPT "Save" RESOURCE "gtk-save" ;
      ACTION Save()

   DEFINE BUTTON OF oBar PROMPT "Preferences" RESOURCE "gtk-preferences" GROUP

   DEFINE BUTTON OF oBar PROMPT "Say" RESOURCE "label" ;
      ACTION AddSay()

   DEFINE BUTTON OF oBar PROMPT "Button" RESOURCE "button" ;
      ACTION AddButton()

   DEFINE BUTTON OF oBar PROMPT "Exit" RESOURCE "gtk-quit" GROUP ;
      ACTION oWndMain:End()

   DEFINE MSGBAR OF oWndMain PROMPT "FiveLinux forms designer"

   oWndMain:SetPos( 0, 0 )
   oWndMain:SetSize( 1024, 100 )

   ACTIVATE WINDOW oWndMain ;
      VALID CloseAllWindows() 

return nil

//----------------------------------------------------------------------------//

function CloseAllWindows()

   local lExit := .F.

   if MsgYesNo( "Want to end ?" )
      while Len( aWindows ) > 0
         ATail( aWindows ):End()
         ASize( aWindows, Len( aWindows ) - 1 )   
      end
      lExit = .T.
   endif   

return lExit

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu, cFileName

   MENU oMenu
      MENUITEM "Files"
      MENU
         MENUITEM "New..." ACTION New()
         MENUITEM "Open..." ACTION Open()
         SEPARATOR
         MENUITEM "Preferences..."
         SEPARATOR

         if Len( oIni:Files ) > 0          
            MENUITEM "Recent files"
            MENU
               for each cFileName in oIni:Files
                  MENUITEM ( cFileName ) ACTION Open( o:cPrompt ) 
               next
               SEPARATOR
               MENUITEM "Clear list" ACTION oIni:ClearSection( "files" )
            ENDMENU
         SEPARATOR
         endif

         MENUITEM "Exit" ACTION oWndMain:End()
      ENDMENU
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

function New()

   DEFINE WINDOW oWnd TITLE "Form"

   ACTIVATE WINDOW oWnd CENTERED

return nil

//----------------------------------------------------------------------------//

function Open()

return nil

//----------------------------------------------------------------------------//

function Save()

return nil

//----------------------------------------------------------------------------//

function LoadPreferences()

   INI oIni FILENAME "./fiveform.ini"

return nil

//----------------------------------------------------------------------------//

function AddButton()
 
   local oBtn

   @ 20, 20 BUTTON oBtn PROMPT "Button" OF oWnd ;
      SIZE 80, 30 PIXEL DESIGN

   oBtn:cVarName = "oBtn" + oBtn:GetCtrlIndex()

   // oBtn:bGotFocus = { || oWndInsp:SetControl( oBtn ) }
 
   /*
   oWndInsp:AddItem( oBtn )
 
   oWndInsp:SetFocus()
   oWnd:SetFocus()
   */ 

return nil

//----------------------------------------------------------------------------//

function AddSay()
 
   local oSay

   @ 20, 20 SAY oSay PROMPT "Label" OF oWnd ;
      SIZE 60, 20 PIXEL DESIGN

   oSay:cVarName = "oSay" + oSay:GetCtrlIndex()

   oSay:bLClicked = { || MsgBeep() }

   // oBtn:bGotFocus = { || oWndInsp:SetControl( oBtn ) }
 
   /*
   oWndInsp:AddItem( oBtn )
 
   oWndInsp:SetFocus()
   oWnd:SetFocus()
   */ 

return nil

//----------------------------------------------------------------------------//
