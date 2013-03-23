#include "FiveLinux.ch"

#define CLR_GRAY1 0xCCCCCC
#define CLR_GRAY2 0xEEEEEE
#define CLR_TEXT  0x303030

function Main()

   local oWnd, oBar, oBrw, oMemo
   local cCode := '#include "FiveLinux.ch"' + CRLF + CRLF + ;
                  "function Test()" + CRLF + CRLF + ;
                  ' MsgInfo( "Hello world!" )' + CRLF + CRLF + ;
                  "return nil"

   if ! File( "scripts.dbf" )
      DbCreate( "scripts.dbf", { { "NAME", "C", 20, 0 },;
                                 { "DESCRIPT", "C", 100, 0 },;
                                 { "CODE", "M", 80, 0 } } )
   endif 

   USE scripts
 
   if RecCount() == 0
      APPEND BLANK
      Scripts->Name := "Test"
      Scripts->Descript := "This is a test script"
      Scripts->Code := cCode
   endif 

   DEFINE WINDOW oWnd MENU BuildMenu() TITLE "Scripts management"

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON OF oBar RESOURCE "gtk-new" ;
      ACTION ( DbAppend(), Scripts->Name := "new script",;
               oBrw:Refresh(), oMemo:SetText( cCode ) )

   DEFINE BUTTON OF oBar RESOURCE "gtk-execute" ;
      ACTION Execute( Scripts->Code )

   DEFINE BUTTON OF oBar RESOURCE "gtk-quit" ACTION oWnd:End()

   @ 7.3, 0 BROWSE oBrw OF oWnd SIZE 450, 600 ;
      FIELDS Scripts->Name, Scripts->Descript ;
      HEADERS "Name", "Description" ;
      COLSIZES 150, 100 ;
      ON CHANGE ( oMemo:SetText( Scripts->Code ), oMemo:Refresh() )   

   oBrw:SetAltColors( CLR_TEXT, CLR_GRAY1, CLR_TEXT, CLR_GRAY2 )

   @ 7.3, 47.5 GET oMemo VAR Scripts->Code MEMO OF oWnd SIZE 805, 600 // FONT oFont

   DEFINE MSGBAR OF oWnd TO " FiveLinux - (c) FiveTech Software 2011"

   ACTIVATE WINDOW oWnd MAXIMIZED

return nil

function BuildMenu

   local oMenu

   MENU oMenu
      MENUITEM "About" ACTION MsgInfo( "Scripts management" + CRLF + CRLF + ;
                                       "(c) FiveTech Software 2013" )
   ENDMENU

return oMenu
