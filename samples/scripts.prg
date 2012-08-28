#include "FiveLinux.ch"

extern HB_CompileFromBuf

function Main()

   local oWnd, oBar, oBrw, oMemo
   local cCode := '#include "FiveLinux.ch"' + CRLF + CRLF + "function Test()" + CRLF + CRLF + ' MsgInfo( "Hello world!" )' + CRLF + CRLF + "return nil"

   if ! File( "scripts.dbf" )
      DbCreate( "scripts.dbf", { { "NAME", "C", 20, 0 }, { "DESCRIPT", "C", 100, 0 }, { "CODE", "M", 80, 0 } } )
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

   DEFINE BUTTON OF oBar RESOURCE "gtk-new" ACTION ( DbAppend(), Scripts->Name := "new script", oBrw:Refresh(), oMemo:SetText( cCode ) )


   DEFINE BUTTON OF oBar RESOURCE "gtk-execute" ACTION Execute()

   DEFINE BUTTON OF oBar RESOURCE "gtk-quit" ACTION oWnd:End()

   @ 7.3, 0 BROWSE oBrw OF oWnd SIZE 450, 640 ;
      FIELDS Scripts->Name, Scripts->Descript ;
      HEADERS "Name", "Description" ;
      COLSIZES 150, 100 ;
      ON CHANGE ( oMemo:SetText( Scripts->Code ), oMemo:Refresh() )   

   @ 7.3, 47.5 GET oMemo VAR Scripts->Code MEMO OF oWnd SIZE 805, 500 // FONT oFont

   DEFINE MSGBAR OF oWnd TO " FiveLinux - (c) FiveTech Software 2011"

   ACTIVATE WINDOW oWnd MAXIMIZED

return nil

function BuildMenu

   local oMenu

   MENU oMenu
      MENUITEM "About"
   ENDMENU

return oMenu

function Execute()

   local oHrb, cResult, bOldError

   // FReOpen_Stderr( "comp.log", "w" )
   oHrb = HB_CompileFromBuf( Scripts->Code, "-n", "-I../../fivelinux/include", "-I../../harbour/include" )
   // oResult:SetText( If( Empty( cResult := MemoRead( "comp.log" ) ), "ok", cResult ) )
 
   if ! Empty( oHrb )
      BEGIN SEQUENCE
         bOldError = ErrorBlock( { | o | DoBreak( o ) } )
         hb_HrbRun( oHrb )
      END SEQUENCE
      ErrorBlock( bOldError )
   endif  
  
return nil

static function DoBreak( oError )
 
   local cInfo := oError:operation, n
 
   if ValType( oError:Args ) == "A"
      cInfo += "   Args:" + CRLF
      for n = 1 to Len( oError:Args )
         MsgInfo( oError:Args[ n ] )
         cInfo += "[" + Str( n, 4 ) + "] = " + ValType( oError:Args[ n ] ) + ;
                   "   " + cValToChar( oError:Args[ n ] ) + CRLF
      next
   endif
 
   MsgStop( oError:Description + CRLF + cInfo,;
            "Script error at line: " + Str( ProcLine( 4 ) ) )
 
   BREAK
 
return nil

