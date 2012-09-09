#include "FiveLinux.ch"

#define CLR_GRAY1 0xCCCCCC
#define CLR_GRAY2 0xEEEEEE
#define CLR_TEXT  0x303030

request DBFCDX

static oWndMain, aWindows := {}, oIni

//----------------------------------------------------------------------------//

function Main()

   local oBar

   SET DATE FORMAT TO "DD/MM/YYYY"

   LoadPreferences()

   DEFINE WINDOW oWndMain TITLE "FiveDbu" ;
      MENU BuildMenu()

   DEFINE BUTTONBAR oBar OF oWndMain

   DEFINE BUTTON OF oBar PROMPT "New" RESOURCE "gtk-new" ;
      ACTION New()

   DEFINE BUTTON OF oBar PROMPT "Open" RESOURCE "gtk-open" ;
      ACTION OpenFile()

   DEFINE BUTTON OF oBar PROMPT "Preferences" RESOURCE "gtk-preferences" GROUP

   DEFINE BUTTON OF oBar PROMPT "Exit" RESOURCE "gtk-quit" GROUP ;
      ACTION oWndMain:End()

   DEFINE MSGBAR OF oWndMain PROMPT "FiveDbu"

   ACTIVATE WINDOW oWndMain MAXIMIZED ;
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
         MENUITEM "Open..." ACTION OpenFile()
         SEPARATOR
         MENUITEM "Preferences..."
         SEPARATOR

         if Len( oIni:Files ) > 0          
            MENUITEM "Recent files"
            MENU
               for each cFileName in oIni:Files
                  MENUITEM ( cFileName ) ACTION OpenFile( o:cPrompt ) 
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

function New( cAlias )

   local oDlg, oBtn, lCopy := .F. 
   local oName, cFieldName := Space( 10 )
   local cType, aType := { "Character", "Number", "Date", "Logical", "Memo" }
   local oLen, nLen := 10
   local oDec, nDec := 0
   local aFields := { { "", "", "", "" } }, cDbfName := Space( 8 )
   local bChange := { || If( cType == "Character", ( nLen := 10, nDec := 0, oDec:Disable() ),),;
                         If( cType == "Number",    ( nLen := 10, nDec := 0, oDec:Enable()  ),),;
                         If( cType == "Date",      ( nLen :=  8, nDec := 0, oDec:Disable() ),),;
                         If( cType == "Logical",   ( nLen :=  1, nDec := 0, oDec:Disable() ),),;
                         If( cType == "Memo",      ( nLen := 10, nDec := 0, oDec:Disable() ),),;
                         oDlg:Update() }
   local bEdit := { || If( ! Empty( aFields[ 1, 1 ] ),;
                      ( oBtn:Enable(),;
                       cFieldName := aFields[ oBrw:nAt, 1 ],;
                       cType := aFields[ oBrw:nArrayAt, 2 ] ,;
                       cType := aType[ aScan(aType, {|x| Left( x, 1 ) = cType } )],;
                       Eval( bChange ),;
                       nLen := aFields[ oBrw:nAt, 3 ],;
                       nDec := aFields[ oBrw:nAt, 4 ],;
                       oGet:SetCurPos( 0 ),;
                       oGet:SetFocus(),;
                       oDlg:Update() ) ,) }

   if ! Empty( cAlias )
      aFields = ( cAlias )->( DbStruct() )
      cTitle = "Modify DBF struct"
   else
      cTitle = "DBF builder"
   endif   

   DEFINE DIALOG oDlg TITLE cTitle SIZE 450, 400

   @ 1,  1 SAY "Field Name" OF oDlg 
   @ 1,  8 SAY "Type" OF oDlg 
   @ 1, 19 SAY "Len" OF oDlg
   @ 1, 25 SAY "Dec" OF oDlg

   @ 3, 1 GET oName VAR cFieldName PICTURE "!!!!!!!!!!" OF oDlg SIZE 82, 22 UPDATE

   @ 3, 10 COMBOBOX cType ITEMS aType ;
      OF oDlg SIZE 100, 26 ON CHANGE Eval( bChange )

   @ 3, 21 GET oLen VAR nLen PICTURE "999" OF oDlg SIZE 50, 22 UPDATE

   @ 3, 27 GET oDec VAR nDec PICTURE "999" OF oDlg SIZE 50, 22 UPDATE

   @ 3, 34 BUTTON "_Add" OF oDlg SIZE 95, 26 ;
      ACTION AddField( @aFields, @cFieldName, @cType, @nLen, @nDec, oName, oBrw )

   @ 6, 34 BUTTON oBtn PROMPT "_Edit" OF oDlg SIZE 95, 26

   @ 9, 34 BUTTON "_Delete" OF oDlg SIZE 95, 26

   @ 12, 34 BUTTON "Move _Up" OF oDlg SIZE 95, 26

   @ 15, 34 BUTTON "Move D_own" OF oDlg SIZE 95, 26

   @ 18, 34 BUTTON "_Cancel" OF oDlg SIZE 95, 26 ACTION oDlg:End()

   @ 7, 0 SAY "Fields:" OF oDlg

   @ 9, 1 BROWSE oBrw ;
      FIELDS aFields[ oBrw:nAt ][ 1 ], aFields[ oBrw:nAt ][ 2 ],;
             aFields[ oBrw:nAt ][ 3 ], aFields[ oBrw:nAt ][ 4 ] ;
      HEADERS "Name", "Type", "Len", "Dec" ;
      COLSIZES 90, 55, 40, 40 ;
      SIZE 295, 230 OF oDlg ;
      ON DBLCLICK Eval( bEdit )

   oBrw:SetArray( aFields )
   oBrw:SetAltColors( CLR_TEXT, CLR_GRAY1, CLR_TEXT, CLR_GRAY2 )

   @ 35, 1 SAY "DBF Name:" OF oDlg

   if ! Empty( cAlias )
      cDbfName = cGetNewAlias( cAlias )
   endif   

   @ 37, 1 GET cDbfName PICTURE "!!!!!!!!!!!!" OF oDlg SIZE 200, 22

   @ 36.5, 34 BUTTON If( Empty( cAlias ), "_Create", "_Save" ) OF oDlg SIZE 95, 26 ;
      ACTION ( If( ! Empty( cDbfName ) .and. Len( aFields ) > 0,;
          DbCreate( AllTrim( cDbfName ), aFields ),), oDlg:End(),;
          lCopy := .T.,;
          oBrwNew := OpenFile( AllTrim( cDbfName ) ) )

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//

function AddField( aFields, cFieldName, cType, nLen, nDec, oGet, oBrw )
 
   if Empty( cFieldName )
      oGet:SetCurPos( 0 )
      return nil
   endif
 
   if Len( aFields ) == 1 .and. Empty( aFields[ 1 ][ 1 ] )
      aFields = { { cFieldName, Upper( Left( cType, 1 ) ), nLen, nDec } }
   else
      AAdd( aFields, { cFieldName, Upper( Left( cType, 1 ) ), nLen, nDec } )
   endif
 
   oBrw:SetArray( aFields )

   cFieldName := Space( 10 )
   oGet:VarPut( "" )
   oGet:Refresh()
   oGet:SetFocus()
   oGet:SetSel( 0, 0 )

   oBrw:GoBottom()
   oBrw:Refresh()
 
return nil
 
//----------------------------------------------------------------------------//

function OpenFile( cFileName )

   local oWnd, oBar, oBrw, oMsgBar, cAlias

   DEFAULT cFileName := cGetFile( "Please select DBF to open", "*.dbf" )

   if Empty( cFileName )
      return nil
   endif

   if ! File( cFileName )
      MsgAlert( cFileName + " does not exist" )
      return nil
   endif 

   oIni:Add( "files", "file" + AllTrim( Str( Len( oIni:Files ) ) ), cFileName )

   USE ( cFileName ) VIA "DBFCDX" NEW SHARED ;
      ALIAS ( cGetNewAlias( Upper( cFileNoExt( cFileNoPath( cFileName ) ) ) ) )
   
   cAlias = Alias()

   DEFINE WINDOW oWnd TITLE "Browse: " + Alias() MENU BuildMenuChild()

   AAdd( aWindows, oWnd )

   oWnd:SetPos( 110 + 40 * Len( aWindows ), 20 + 40 * Len( aWindows ) )
   oWnd:SetSize( 700, 400 )

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON OF oBar PROMPT "Add" RESOURCE "gtk-add" ;
      ACTION ( ( oBrw:cAlias )->( DbAppend() ), oBrw:GoBottom(), oBrw:Refresh(), oBrw:SetFocus() )

   DEFINE BUTTON OF oBar PROMPT "Edit" RESOURCE "gtk-edit" ;
      ACTION ( cAlias )->( Edit( cFileName ) )

   DEFINE BUTTON OF oBar PROMPT "Del" RESOURCE "gtk-delete" ;
      ACTION ( obrw:cAlias )->( DelRecord( oBrw /*, oMsgDeleted */ ) )

   DEFINE BUTTON OF oBar PROMPT "Top" RESOURCE "gtk-goto-top" GROUP ;
      ACTION oBrw:GoTop()

   DEFINE BUTTON OF oBar PROMPT "Bottom" RESOURCE "gtk-goto-bottom" ;
      ACTION oBrw:GoBottom()

   DEFINE BUTTON OF oBar PROMPT "Indexes" RESOURCE "gtk-sort-ascending" GROUP ;
      ACTION ( cAlias )->( Indexes( cFileName ) )

   DEFINE BUTTON OF oBar PROMPT "Properties" RESOURCE "gtk-properties" GROUP ;
      ACTION ( cAlias )->( Properties( cFileName ) )

   DEFINE BUTTON OF oBar PROMPT "Print" RESOURCE "gtk-print" GROUP ;
      ACTION oBrw:Report( .T. )

   DEFINE BUTTON OF oBar PROMPT "Close" RESOURCE "gtk-close" GROUP ;
      ACTION ( ( cAlias )->( DbCloseArea() ), oWnd:End() ) 

   @ 5.5, 0 BROWSE oBrw OF oWnd SIZE 682, 300 ;
      ON CHANGE oMsgBar:SetText( cFileName + Space( 50 ) + ;
                                 If( ( cAlias )->( Deleted() ), "| Deleted |", "| Not deleted |" ) + ;
                                 " RecNo: " + AllTrim( Str( ( cAlias )->( RecNo() ) ) ) + " / " + ;
                                 AllTrim( Str( ( cAlias )->( RecCount() ) ) ) + " |" ) ;
      ON DBLCLICK ( cAlias )->( Edit( cFileName ) )

   oBrw:SetAltColors( CLR_TEXT, CLR_GRAY1, CLR_TEXT, CLR_GRAY2 )
   oBrw:SetFocus()

   DEFINE MSGBAR oMsgBar OF oWnd PROMPT cFileName

   Eval( oBrw:bChange )

   ACTIVATE WINDOW oWnd ;
      ON RESIZE oBrw:SetSize( nWidth - 20, nHeight - 92 )

return nil

//----------------------------------------------------------------------------//

function Edit( cFileName )

   local oWnd, oBar, oBrw, oMsgBar, cAlias := Alias()
   local aNames := GetFieldNames()

   DEFINE WINDOW oWnd TITLE "Edit: " + cAlias MENU BuildMenuChild()

   AAdd( aWindows, oWnd )

   oWnd:SetPos( 110 + 40 * Len( aWindows ), 20 + 40 * Len( aWindows ) )
   oWnd:SetSize( 700, 400 )

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON OF oBar PROMPT "Save" RESOURCE "gtk-save"

   DEFINE BUTTON OF oBar PROMPT "Previous" RESOURCE "gtk-go-back" GROUP ;
      ACTION ( ( cAlias )->( DbSkip( -1 ) ), oBrw:Refresh(), Eval( oBrw:bChange ) )

   DEFINE BUTTON OF oBar PROMPT "Next" RESOURCE "gtk-go-forward" ;
      ACTION ( ( cAlias )->( DbSkip( 1 ) ), oBrw:Refresh(), Eval( oBrw:bChange ) )

   DEFINE BUTTON OF oBar PROMPT "Print" RESOURCE "gtk-print" GROUP

   DEFINE BUTTON OF oBar PROMPT "Close" RESOURCE "gtk-close" GROUP ;
      ACTION oWnd:End() 

   @ 5.5, 0 BROWSE oBrw OF oWnd SIZE 682, 300 ;
      FIELDS aNames[ oBrw:nAt ], FieldGet( oBrw:nAt ) ;
      HEADER "Field", "Value" ;
      ON CHANGE oMsgBar:SetText( cFileName + Space( 50 ) + ;
                                 If( ( cAlias )->( Deleted() ), "| Deleted |", "| Not deleted |" ) + ;
                                 " RecNo: " + AllTrim( Str( ( cAlias )->( RecNo() ) ) ) + " / " + ;
                                 AllTrim( Str( ( cAlias )->( RecCount() ) ) ) + " |" )

   oBrw:SetArray( GetFieldNames() )
   oBrw:SetAltColors( CLR_TEXT, CLR_GRAY1, CLR_TEXT, CLR_GRAY2 )
   oBrw:SetFocus()
   oBrw:bLClicked = { || oBrw:Edit( 2 ) } 
   oBrw:Edit( 2 )

   DEFINE MSGBAR oMsgBar OF oWnd PROMPT cFileName

   Eval( oBrw:bChange )

   ACTIVATE WINDOW oWnd ;
      ON RESIZE oBrw:SetSize( nWidth - 20, nHeight - 92 )

return nil

//----------------------------------------------------------------------------//

function Indexes( cFileName )

   local oWnd, oBar, oBrw, oMsgBar
   local cAlias := Alias(), aIndexes := Array( OrdCount() )

   DEFINE WINDOW oWnd TITLE "Indexes: " + cAlias MENU BuildMenuChild()

   AAdd( aWindows, oWnd )

   oWnd:SetPos( 110 + 40 * Len( aWindows ), 20 + 40 * Len( aWindows ) )
   oWnd:SetSize( 700, 400 )

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON OF oBar PROMPT "Add" RESOURCE "gtk-add" ;
      ACTION ( IndexBuilder(), oBrw:Refresh(), oBrw:SetFocus() )
 
   DEFINE BUTTON OF oBar PROMPT "Edit" RESOURCE "gtk-edit" ;
      ACTION ( MsgInfo( "Edit" ) )
 
   DEFINE BUTTON OF oBar PROMPT "Del" RESOURCE "gtk-delete" ;
      ACTION If( MsgYesNo( "Want to delete this tag ?" ),;
                ( ( cAlias )->( OrdDestroy( oBrw:nAt ) ), oBrw:Refresh() ),)

   DEFINE BUTTON OF oBar PROMPT "Print" RESOURCE "gtk-print" GROUP

   DEFINE BUTTON OF oBar PROMPT "Close" RESOURCE "gtk-close" GROUP ;
      ACTION oWnd:End() 

   @ 5.5, 0 BROWSE oBrw OF oWnd SIZE 682, 300 ;
      HEADERS "Order", "TagName", "Expression", "For", "BagName", "BagExt" ;
      FIELDS oBrw:nAt,;
             ( cAlias )->( OrdName( oBrw:nAt ) ),;
             ( cAlias )->( OrdKey ( oBrw:nAt ) ),;
             ( cAlias )->( OrdFor ( oBrw:nAt ) ),;
             ( cAlias )->( OrdBagName( oBrw:nAt ) ),;
             ( cAlias )->( OrdBagExt( oBrw:nAt ) ) ;
      COLSIZES 50, 100, 400, 240, 100, 100

   oBrw:SetArray( aIndexes )
   oBrw:SetAltColors( CLR_TEXT, CLR_GRAY1, CLR_TEXT, CLR_GRAY2 )
   oBrw:SetFocus()

   DEFINE MSGBAR oMsgBar OF oWnd PROMPT cFileName

   // Eval( oBrw:bChange )

   ACTIVATE WINDOW oWnd ;
      ON RESIZE oBrw:SetSize( nWidth - 20, nHeight - 92 )

return nil

//----------------------------------------------------------------------------//

function IndexBuilder()

return nil

//----------------------------------------------------------------------------//

function Properties( cFileName )

   local oWnd, oBar, oBrw, oMsgBar
   local aInfo := DbStruct()

   DEFINE WINDOW oWnd TITLE "Structure: " + Alias() ;
      MENU BuildMenuChild()

   oWnd:SetSize( 150, 400 )

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON OF oBar PROMPT "Code" RESOURCE "gtk-find" ;
      ACTION TxtStruct( Alias() )

   DEFINE BUTTON OF oBar PROMPT "Close" RESOURCE "gtk-close" GROUP ;
      ACTION oWnd:End()

   @ 5.5, 0 BROWSE oBrw OF oWnd SIZE 481, 307 ;
      FIELDS aInfo[ oBrw:nAt ][ 1 ], aInfo[ oBrw:nAt ][ 2 ],;
             aInfo[ oBrw:nAt ][ 3 ], aInfo[ oBrw:nAt ][ 4 ] ;
      HEADERS "Name", "Type", "Len", "Dec" ;
      COLSIZES 120, 120, 120, 120 

   oBrw:SetArray( aInfo )
   oBrw:SetAltColors( CLR_TEXT, CLR_GRAY1, CLR_TEXT, CLR_GRAY2 )
   oBrw:SetFocus()

   DEFINE MSGBAR oMsgBar OF oWnd PROMPT cFileName

   ACTIVATE WINDOW oWnd CENTERED

return nil

//----------------------------------------------------------------------------//

function TxtStruct( cAlias )
 
   local cCode := "local aFields := { ", n
 
   for n = 1 to FCount()
      if n > 1
         cCode += Space( 27 )
      endif
      cCode += '{ "' + FieldName( n ) + '", "' + ;
               FieldType( n ) + '", ' + ;
               AllTrim( Str( FieldLen( n ) ) ) + ", " + ;
               AllTrim( Str( FieldDec( n ) ) ) + " },;" + CRLF
   next
 
   cCode = SubStr( cCode, 1, Len( cCode ) - 4 ) + " }" + CRLF + CRLF
 
   cCode += 'DbCreate( "myfile.dbf", aFields, "' + RddName() + '" )'
 
   MemoEdit( cCode, "Code: " + cAlias )
 
return nil

//----------------------------------------------------------------------------//

static function DelRecord( oBrw, oMsgDeleted )

   if ! Deleted()
      if ! MsgYesNo( "Want to delete this record ?" )
         return nil
      endif
      DbRLock()
      DbDelete()
      DbUnlock()
      if oMsgDeleted != nil
         oMsgDeleted:SetText( "DELETED" )
         oMsgDeleted:SetBitmap( "deleted" )
      endif
   else
      DbRLock()
      DbRecall()
      DbUnlock()
      if oMsgDeleted != nil
         oMsgDeleted:SetText( "NON DELETED" )
         oMsgDeleted:SetBitmap( "nondeleted" )
      endif
      MsgInfo( "UnDeleted record" )
   endif

   if oBrw:bChange != nil 
      Eval( oBrw:bChange )
   endif
   oBrw:Refresh()

return nil

//----------------------------------------------------------------------------//

function BuildMenuChild()

   local oMenu

   MENU oMenu
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

function LoadPreferences()

   INI oIni FILE "./fivedbu.ini"

return nil

//----------------------------------------------------------------------------//
