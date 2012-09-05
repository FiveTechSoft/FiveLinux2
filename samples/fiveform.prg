// FiveLinux forms designer

#include "FiveLinux.ch"

#define CLR_GRAY1 0xCCCCCC
#define CLR_GRAY2 0xEEEEEE
#define CLR_TEXT  0x303030

static oWndMain, oWnd, aForms := {}, oWndInsp, oIni

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

   DEFINE BUTTON OF oBar RESOURCE "gtk-preferences"

   DEFINE BUTTON OF oBar PROMPT "Say" ;
      FILENAME "./../bitmaps/say.png" ;
      ACTION AddSay()

   DEFINE BUTTON OF oBar PROMPT "Button" ;
      FILENAME "./../bitmaps/button.png" ;
      ACTION AddButton()

   DEFINE BUTTON OF oBar PROMPT "Get" ;
      FILENAME "./../bitmaps/get.png" ;
      ACTION AddGet()

   DEFINE BUTTON OF oBar PROMPT "CheckBox" ;
      FILENAME "./../bitmaps/checkbox.png" ;
      ACTION AddCheckbox()

   DEFINE BUTTON OF oBar PROMPT "Listbox" ;
      FILENAME "./../bitmaps/listbox.png" ;
      ACTION AddListbox()

   DEFINE BUTTON OF oBar PROMPT "ComboBox" ;
      FILENAME "./../bitmaps/combobox.png" ;
      ACTION AddComboBox()

   DEFINE BUTTON OF oBar PROMPT "Browse" ;
      FILENAME "./../bitmaps/browse.png" ;
      ACTION AddBrowse()

   DEFINE BUTTON OF oBar PROMPT "Exit" RESOURCE "gtk-quit" GROUP ;
      ACTION oWndMain:End()

   DEFINE MSGBAR OF oWndMain PROMPT "FiveLinux forms designer"

   oWndMain:SetPos( 0, 0 )
   oWndMain:SetSize( 1024, 100 )

   New()

   ACTIVATE WINDOW oWndMain ;
      VALID CloseAllWindows() 

return nil

//----------------------------------------------------------------------------//

function CloseAllWindows()

   local lExit := .F.

   if MsgYesNo( "Want to end ?" )
      while Len( aForms ) > 0
         ATail( aForms ):End()
         ASize( aForms, Len( aForms ) - 1 )   
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
         MENUITEM "Save..." ACTION Save()
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

   DEFINE WINDOW oWnd

   AAdd( aForms, oWnd )
   oWnd:cVarName = "oForm" + AllTrim( Str( Len( aForms ) ) )
   oWnd:SetText( "Form" + AllTrim( Str( Len( aForms ) ) ) ) 

   oWnd:SetPos( 200, 440 )
   oWnd:Show()

   oWnd:bLClicked = { | nRow, nCol | oWndInsp:SetForm( oWnd ) }
   oWnd:bRClicked = { | nRow, nCol | ShowPopup( nRow, nCol, oWnd ) }

   if oWndInsp == nil
      oWndInsp = BuildInspector()
   endif 

   oWndInsp:SetForm( oWnd )

return nil

//----------------------------------------------------------------------------//

function ShowPopup( nRow, nCol, oWnd )

   local oPopup

   MENU oPopup POPUP
      MENUITEM "Source code..." ;
         ACTION MemoEdit( oWnd:cGenPrg(), "Source code" ) 
   ENDMENU

   ACTIVATE MENU oPopup OF oWnd AT nRow, nCol

return nil

//----------------------------------------------------------------------------//

function Open( cFileName )

   local n
 
   DEFAULT cFileName := cGetFile( "Select form to open", "*.prg" )
 
   if File( cFileName )
      oWnd = Execute( MemoRead( cFileName ) )
      HB_SetClsHandle( oWnd, TForm():ClassH )
      oWnd:Initiate()  
      oWnd:lDesign = .T.
      // oWnd:oInspector = oWndInsp
      // oWnd:bLClicked = { | nRow, nCol, nFlags, Self | oWnd := Self, oWndInsp:SetForm( oWnd ) }
      oWnd:bRClicked = { | nRow, nCol | ShowPopup( nRow, nCol, oWnd ) }
 
      for n = 1 to Len( oWnd:aControls )
         oWnd:aControls[ n ]:bGotFocus = GenLocalFocusBlock( oWnd:aControls[ n ] )
         if oWnd:aControls[ n ]:ClassName() == "TSay"
            oWnd:aControls[ n ]:lWantClick = .T.
         endif   
      next   
 
      // oWndInsp:SetForm( oWnd )
      // oWndInsp:Show()
 
      AAdd( aForms, oWnd )
   endif   
 
return nil
 
//----------------------------------------------------------------------------//

static function GenLocalFocusBlock( oCtrl )
 
return { || oWndInsp:SetControl( oCtrl ) }

//----------------------------------------------------------------------------//

function Save()

   local cFileName := cGetFile( "Save as", oWnd:cVarName + ".prg" )

   MemoWrit( cFileName, oWnd:cGenPrg() ) 

return nil

//----------------------------------------------------------------------------//

function LoadPreferences()

   INI oIni FILENAME "./fiveform.ini"

return nil

//----------------------------------------------------------------------------//

function AddBrowse()
 
   local oBtn

   @ 20, 20 BROWSE oBrw ;
      FIELDS "", "", "" ;
      HEADERS "Col 1", "Col 2", "Col 3" ;
      COLSIZES 70, 70, 70 ;
      OF oWnd SIZE 220, 162 PIXEL DESIGN

   oBrw:cVarName = "oBrw" + oBrw:GetCtrlIndex()

   // oBtn:bGotFocus = { || oWndInsp:SetControl( oBtn ) }
 
   /*
   oWndInsp:AddItem( oBtn )
 
   oWndInsp:SetFocus()
   oWnd:SetFocus()
   */ 

return nil

//----------------------------------------------------------------------------//

function AddButton()
 
   local oBtn

   @ 20, 20 BUTTON oBtn PROMPT "Button" OF oWnd ;
      SIZE 80, 30 PIXEL DESIGN

   oBtn:cVarName = "oBtn" + oBtn:GetCtrlIndex()

   oBtn:bGotFocus = { || oWndInsp:SetControl( oBtn ) }

   oWndInsp:AddItem( oBtn )
   oWndInsp:SetControl( oBtn )
 
   oWndInsp:Refresh()
   oWnd:SetFocus()

return nil

//----------------------------------------------------------------------------//
 
function AddCheckbox()
 
   local oChk, lValue := .F.
 
   @ 20, 20 CHECKBOX oChk VAR lValue PROMPT "Checkbox" OF oWnd ;
      SIZE 90, 25 PIXEL DESIGN
 
   oChk:cVarName = "oChk" + oChk:GetCtrlIndex()
   oChk:bGotFocus = { || oWndInsp:SetControl( oChk ) }
 
   // oWndInsp:AddItem( oChk )
 
   // oWndInsp:SetFocus()
   // oWnd:SetFocus()
 
return nil
 
//----------------------------------------------------------------------------//

function AddComboBox()
 
   local oCbx, cItem, aItems := { "one", "two", "three" }
 
   @ 20, 20 COMBOBOX oCbx VAR cItem ITEMS aItems OF oWnd ;
      SIZE 120, 120 PIXEL DESIGN
 
   oCbx:cVarName = "oCbx" + oCbx:GetCtrlIndex()
   oCbx:bGotFocus = { || oWndInsp:SetControl( oCbx ) }

   // oWndInsp:AddItem( oCbx )
 
   // oWndInsp:SetFocus()
   oWnd:SetFocus()
 
return nil
 
//----------------------------------------------------------------------------//

function AddGet()
 
   local oGet, cValue := Space( 20 )
 
   @ 20, 20 GET oGet VAR cValue OF oWnd ;
      SIZE 120, 25 PIXEL DESIGN
 
   oGet:cVarName = "oGet" + oGet:GetCtrlIndex()
   oGet:bGotFocus = { || oWndInsp:SetControl( oGet ) }
 
   // oWndInsp:AddItem( oGet )
 
   // oWndInsp:SetFocus()
   oWnd:SetFocus()
 
return nil
 
//----------------------------------------------------------------------------//

function AddListbox()
 
   local oLbx, cItem, aItems := { "one", "two", "three" }
 
   @ 20, 20 LISTBOX oLbx VAR cItem ITEMS aItems OF oWnd ;
      SIZE 120, 120 PIXEL DESIGN
 
   oLbx:cVarName = "oLbx" + oLbx:GetCtrlIndex()
   oLbx:bGotFocus = { || oWndInsp:SetControl( oLbx ) }

   // oWndInsp:AddItem( oGet )
 
   // oWndInsp:SetFocus()
   oWnd:SetFocus()
 
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

function BuildInspector()

   local oWnd := TInspector():New()

return oWnd

//----------------------------------------------------------------------------//

CLASS TInspector FROM TWindow
 
   DATA   oCtrl         // Inspected control
   DATA   oCbxControls
   DATA   oFld
   DATA   oBrwProps
   // DATA   oBrwEvents
 
   METHOD New()
 
   METHOD BuildBrwProps()
 
   METHOD AddItem( oCtrl )
 
   METHOD SetControl( oCtrl )
 
   METHOD SetForm( oForm )
 
   METHOD Refresh() INLINE ::oBrwProps:Refresh()
 
ENDCLASS   

//----------------------------------------------------------------------------//

METHOD New() CLASS TInspector

   local cVal := ""
 
   Super:New()
 
   ::SetText( "Object Inspector" )
   ::SetSize( 287, 342 )
   ::SetPos( 183, 60 )
 
   @ 12, 13 COMBOBOX ::oCbxControls VAR cVal OF Self PIXEL SIZE 262, 20

   @ 46, 13 FOLDER ::oFld PROMPTS "Properties", "Events" ;
      OF Self PIXEL SIZE 262, 287
 
   ::BuildBrwProps()
 
   /*
   ::bReSized = { || If( ::oBrwProps != nil, ::oBrwProps:aCols[ 2 ]:nWidth := ::nWidth - ;
                     ::oBrwProps:aCols[ 1 ]:nWidth - 63,) }
   */
 
   ::Show()
   ::bValid = { || .F. } // can't be closed
 
return Self

//----------------------------------------------------------------------------//

METHOD BuildBrwProps() CLASS TInspector

   @ 75, 14 BROWSE ::oBrwProps ;
      FIELDS ::oCtrl:aProperties[ ::oBrwProps:nAt ],;
             cValToChar( __ObjSendMsg( ::oCtrl,;
                         ::oCtrl:aProperties[ ::oBrwProps:nAt ] ) ) ;
      HEADERS "Data", "Value" ;
      SIZE 240, 240 PIXEL OF ::oFld:aDialogs[ 1 ]

   ::oBrwProps:SetArray( If( ::oCtrl != nil, ::oCtrl:aProperties, {} ) )
   ::oBrwProps:SetAltColors( CLR_TEXT, CLR_GRAY1, CLR_TEXT, CLR_GRAY2 )

return nil

//----------------------------------------------------------------------------//
 
METHOD AddItem( oCtrl ) CLASS TInspector
 
   AAdd( ::oCbxControls:aItems, oCtrl:cVarName + " AS " + ;
         oCtrl:ClassName() )
 
   ::oCbxControls:SetItems( ::oCbxControls:aItems )
   ::oCbxControls:Select( Len( ::oCbxControls:aItems ) )
 
return nil                         
 
//----------------------------------------------------------------//
 
METHOD SetControl( oCtrl ) CLASS TInspector
 
   local nAt := AScan( ::oCbxControls:aItems,;
      { | cItem | SubStr( cItem, 1, Len( oCtrl:cVarName ) ) == oCtrl:cVarName } )
 
   if nAt != 0
      if ::oCbxControls:GetText() != ::oCbxControls:aItems[ nAt ]
         ::oCbxControls:Select( nAt )
      endif
   endif
 
   ::oCtrl = oCtrl
   ::Refresh()
 
return nil
 
//----------------------------------------------------------------//
 
METHOD SetForm( oForm ) CLASS TInspector
 
   local aItems := {}, n, oCtrl
 
   if ! ::oCtrl == oForm
      ::oCtrl = oForm
      AAdd( aItems, oForm:cVarName + " AS " + oForm:ClassName() )
      for n = 1 to Len( oForm:aControls )
         oCtrl = oForm:aControls[ n ]
         if oCtrl:ClassName() != "TSCROLLBAR"
            AAdd( aItems, oCtrl:cVarName + " AS " + oCtrl:ClassName() )
         endif
      next   
      ::oCbxControls:SetItems( aItems )
      ::oCbxControls:Select( 1 )
      ::oBrwProps:SetArray( oForm:aProperties )
      ::oBrwProps:Refresh()
   endif
 
return nil
 
//----------------------------------------------------------------// 
