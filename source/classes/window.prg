#include "FiveLinux.ch"

static aWindows := {}
static oWndDefault

//----------------------------------------------------------------------------//

CLASS TWindow

   DATA      hWnd   // An internal handle of the window, dialog or control
   DATA      oWnd   // The container parent window or dialog
   DATA      oMenu  // The pulldown menu object if defined
   DATA      oPopup // The popup menu object if defined
   DATA      oMsgBar // The message bar object if defined
   DATA      aControls INIT {} // An array with all the child controls objects
   DATA      bValid // A block to allow the close or focus loose on controls
   DATA      bLClicked // A codeblock to evaluate when the mouse is L clicked
   DATA      bLDblClick // A codeblock to evaluate when the mouse is L double clicked
   DATA      bRClicked // A codeblock to evaluate when the mouse is R clicked
   DATA      bReSized // A codeblock to evaluate when the window is resized
   DATA      bKeyDown // A codeblock to evaluate when a key is pressed
   DATA      bGotFocus // A codeblock to evaluate when the focus is gained
   DATA      bLostFocus // A codeblock to evaluate when the focus is lost
   DATA      Cargo // user defined cargo value
   DATA      bStart // codeblock to evaluate after the window is painted for the first time
   DATA      oFont  // used font object
   DATA      nClrText, nClrPane
   DATA      cVarName // variable name that holds this object

   METHOD New( cTitle, oMenu, nWidth, nHeight, cVarName )

   METHOD Activate( bValid, bLClicked, bRClicked, lMaximized, lCentered, bResized )

   METHOD AddControl( oCtrl ) INLINE If( ::aControls == nil,;
          ::aControls := {}, AAdd( ::aControls, oCtrl ) ), oCtrl:oWnd := Self

   METHOD AEvalWhen()

   METHOD Center() INLINE WndCenter( ::hWnd )

   METHOD cGenPrg()

   METHOD _cToolTip( cText ) INLINE WndSetToolTip( ::hWnd, cText )

   METHOD Disable() INLINE WndEnable( ::hWnd, .f. )

   METHOD Enable() INLINE WndEnable( ::hWnd, .t. )

   METHOD End()

   METHOD GenLocals()

   METHOD GetText() INLINE WndGetText( ::hWnd )

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD Hide() INLINE WndHide( ::hWnd )

   METHOD LButtonDown( nRow, nCol ) INLINE ;
          If( ::bLClicked != nil, Eval( ::bLClicked, nRow, nCol, Self ),)

   METHOD LDblClick( nRow, nCol ) INLINE ;
          If( ::bLDblClick != nil, Eval( ::bLDblClick, nRow, nCol, Self ),)

   METHOD lFocused() INLINE GetFocus() == ::hWnd

   METHOD Link()

   METHOD Maximize() INLINE WndMaximize( ::hWnd )

   METHOD nLeft() INLINE If( ::oWnd != nil, GetLeft( ::hWnd ), WndGetPos( ::hWnd )[ 1 ] )

   METHOD nHeight() INLINE GetHeight( ::hWnd )

   METHOD nTop() INLINE If( ::oWnd != nil, GetTop( ::hWnd ), WndGetPos( ::hWnd )[ 2 ] )

   METHOD nWidth() INLINE GetWidth( ::hWnd )

   METHOD RButtonDown() INLINE If( ::bRClicked != nil, Eval( ::bRClicked, Self ),)

   METHOD Refresh() INLINE WndRefresh( ::hWnd )

   METHOD ReSize( nWidth, nHeight )

   METHOD SetColor( nClrText, nClrPane ) INLINE ::nClrText := nClrText, ::nClrPane := nClrPane

   METHOD SetFocus() INLINE SetFocus( ::hWnd )

   METHOD SetMenu( oMenu )

   METHOD SetPos( nTop, nLeft ) INLINE WndSetPos( ::hWnd, nLeft, nTop )

   METHOD SetSize( nWidth, nHeight ) INLINE WndSetSize( ::hWnd, nWidth, nHeight )

   METHOD SetText( cText ) INLINE WndSetText( ::hWnd, cText )

   METHOD Show()  INLINE ShowWindow( ::hWnd )

   METHOD Update() INLINE ;
      AEval( ::aControls, { |o| If( o:lUpdate, o:Refresh(),) } )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cTitle, oMenu, nWidth, nHeight, cVarName ) CLASS TWindow

   DEFAULT cTitle := "FiveLinux", nWidth := 522, nHeight := 314

   ::hWnd   = CreateWindow()
   ::aControls = {}
   ::cVarName = cVarName

   ::SetText( cTitle )

   ::Link()

   SetWndDefault( Self )

   if oMenu != nil
      ::SetMenu( oMenu )
   endif

   ::SetSize( nWidth, nHeight )

return Self

//----------------------------------------------------------------------------//

METHOD Activate( bValid, bLClicked, bRClicked, lMaximized, lCentered, bResized ) CLASS TWindow

   DEFAULT lMaximized := .F., lCentered := .F.

   ::bValid    = bValid
   ::bLClicked = bLClicked
   ::bRClicked = bRClicked
   
   if bResized != nil
      ::bResized = bResized
   endif

   if lMaximized
      ::Maximize()
   endif

   if lCentered
      ::Center()
   endif

   ::AEvalWhen()
   ::Show()

   WinRun()

return nil

//----------------------------------------------------------------------------//

METHOD AEvalWhen() CLASS TWindow

   local n

   for n = 1 to Len( ::aControls )
      if ::aControls[ n ]:bWhen != nil
         if ! Eval( ::aControls[ n ]:bWhen, ::aControls[ n ] )
            ::aControls[ n ]:Disable()
	 else
	    ::aControls[ n ]:Enable()
	 endif
      endif
   next

return nil

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TWindow

   local cCode := ""

   cCode += '#include "FiveLinux.ch"' + CRLF + CRLF
   cCode += "//" + Replicate( "-", 76 ) + "//" + CRLF + CRLF
   cCode += "function BuildWindow()" + CRLF + CRLF

   cCode += ::GenLocals() + CRLF + CRLF

   cCode += "   DEFINE WINDOW " + ::cVarName + ;
            ' TITLE "' + ::GetText() + '" ;' + CRLF + ;
            "      SIZE " + AllTrim( Str( ::nWidth ) ) + ", " + ;
                          + AllTrim( Str( ::nHeight ) )

   if ! Empty( ::aControls )
      cCode += CRLF
      AEval( ::aControls, { | oCtrl | cCode += oCtrl:cGenPRG() } )
   else
      cCode += CRLF
   endif

   cCode += CRLF + "   ACTIVATE WINDOW " + ::cVarName + " CENTERED" + CRLF + CRLF

   cCode += "return " + ::cVarName + CRLF + CRLF
   cCode += "//" + Replicate( "-", 76 ) + "//" + CRLF

return cCode

//----------------------------------------------------------------------------//

METHOD End() CLASS TWindow

   local lEnd := .t.

   if ::hWnd == nil
      return nil
   endif

   if ::bValid != nil
      lEnd = Eval( ::bValid, Self )
   endif

   if lEnd
      SysQuit( ::hWnd )
      ::hWnd = nil
   endif

return lEnd

//----------------------------------------------------------------------------//

METHOD GenLocals() CLASS TWindow
 
   local cLocals := "   local " + ::cVarName, n
 
   for n = 1 to Len( ::aControls )
      cLocals += ::aControls[ n ]:GenLocals()
   next
 
return cLocals    
 
//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TWindow

   do case
      case nMsg == WM_CLOSE
	   return ::End()

      case nMsg == WM_MENUCMD
	   if ::oPopup != nil
	      ::oPopup:Command( nWParam )
	      ::oPopup = nil
	      return nil
	   else
	      return ::oMenu:Command( nWParam )
	   endif

       case nMsg == WM_LBUTTONDOWN
	    return ::LButtonDown( nWParam, nLParam )

       case nMsg == WM_LDBLCLICK
            return ::LDblClick( nWParam, nLParam )       

       case nMsg == WM_RBUTTONDOWN
	    return ::RButtonDown()

       case nMsg == WM_SIZE
	    return ::ReSize( nWParam, nLParam )

       case nMsg == WM_BTNPRESS  // drag operation
            return ::BtnPress( nWParam, nLParam )

       case nMsg == WM_MOTION
            return ::Motion()
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD Link() CLASS TWindow

   local nAt := AScan( aWindows, 0 )

   if ::hWnd != 0
      if nAt != 0
         aWindows[ nAt ] = Self
      else
         AAdd( aWindows, Self )
         nAt = Len( aWindows )
      endif
      SetProp( ::hWnd, "WP", nAt )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReSize( nWidth, nHeight ) CLASS TWindow

   if ::bResized != nil
      Eval( ::bResized, nWidth, nHeight, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetMenu( oMenu ) CLASS TWindow

   ::oMenu = oMenu
   SetMenu( ::hWnd, oMenu:hMenu )
   SetMenuProp( oMenu, GetProp( ::hWnd, "WP" ) )

return nil

//----------------------------------------------------------------------------//

function _FLH( nMsg, nWParam, nLParam, nAt )

   local oWnd

   if nAt != 0
      oWnd = aWindows[ nAt ]
      if ValType( oWnd ) == "O"
         return oWnd:HandleEvent( nMsg, nWParam, nLParam )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

function GetAllWin()

return aWindows

//----------------------------------------------------------------------------//

function SetWndDefault( oWnd )

   oWndDefault = oWnd

return nil

//----------------------------------------------------------------------------//

function GetWndDefault()

return oWndDefault

//----------------------------------------------------------------------------//

init procedure flh_init

   __gtkinit()

return

//----------------------------------------------------------------------------//
