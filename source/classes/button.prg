#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TButton FROM TControl

   DATA   bAction   // The action to execute when the button is clicked

   METHOD New( nRow, nCol, cText, oWnd, bAction, nWidth, nHeight, bValid,;
               bWhen, lUpdate, cImgName, oFont, lDesign, lPixel, cVarName )

   METHOD NewBar( oBar, cText, cImgName, bAction, lGroup )

   METHOD Redefine( cId, oWnd, bAction, bValid, bWhen, lUpdate )

   METHOD cGenPrg()

   METHOD Click()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD SetText( cText ) INLINE BtnSetText( ::hWnd, cText )

   METHOD GetText() INLINE BtnGetText( ::hWnd )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, cText, oWnd, bAction, nWidth, nHeight, bValid,;
            bWhen, lUpdate, cImgName, oFont, lDesign, lPixel, cVarName ) CLASS TButton

   DEFAULT cText := "_Button", oWnd := GetWndDefault(), nWidth := 80,;
           nHeight := 27, lUpdate := .F., lDesign := .F., lPixel := .F.

   ::bAction   = bAction
   ::hWnd      = CreateButton( cText, cImgName )
   ::bValid    = bValid
   ::bWhen     = bWhen
   ::lUpdate   = lUpdate
   ::lDrag     = lDesign
   ::cVarName  = cVarName

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow * If( lPixel, 1, 10 ), nCol * If( lPixel, 1, 10 ) )
   ::SetSize( nWidth, nHeight )

   if ! Empty( oFont )
      ::SetFont( oFont )
   endif

   ::Link()
   ::Show()

return Self

//----------------------------------------------------------------------------//

METHOD NewBar( oBar, cText, cImgName, bAction, lGroup ) CLASS TButton

   DEFAULT lGroup := .f.

   ::hWnd = CreateBtn( oBar:hWnd, cText, cImgName, lGroup )
   ::bAction = bAction

   oBar:AddControl( Self )

   ::Link()

return Self

//----------------------------------------------------------------------------//

METHOD Redefine( cId, oWnd, bAction, bValid, bWhen, lUpdate ) CLASS TButton

   DEFAULT oWnd := GetWndDefault(), lUpdate := .f.

   ::bAction   = bAction
   ::hWnd      = LoadButton( cId )
   ::bValid    = bValid
   ::bWhen     = bWhen
   ::lUpdate   = lUpdate

   oWnd:AddControl( Self )

   ::Link()

return Self

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TButton

   local cCode := ""
   local cTop, cLeft, cWidth, cHeight
 
   cTop    = LTrim( Str( Int( ::nTop ) ) )
   cLeft   = LTrim( Str( Int( ::nLeft ) ) )
   cWidth  = LTrim( Str( Int( ::nWidth ) ) )
   cHeight = LTrim( Str( Int( ::nHeight ) ) )
 
   cCode += CRLF + "   @ " + cTop + ", " + cLeft + ;
            " BUTTON " + ::cVarName + ' PROMPT "' + ::GetText() + '"' + ;
            " ;" + CRLF + '      SIZE ' + cWidth + ", " + cHeight + ;
            " PIXEL OF " + ::oWnd:cVarName + " ;" + CRLF + ;
            '      ACTION MsgInfo( "Not defined yet!" )' + CRLF
 
return cCode

//----------------------------------------------------------------------------//

METHOD Click() CLASS TButton

   if ::bAction != nil
      Eval( ::bAction, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TButton

   do case
      case nMsg == WM_CLICK
           return ::Click()
   endcase

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//
