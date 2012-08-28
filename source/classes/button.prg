#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TButton FROM TControl

   DATA   bAction   // The action to execute when the button is clicked

   METHOD New( nRow, nCol, cText, oWnd, bAction, nWidth, nHeight, bValid,;
               bWhen, lUpdate, cImgName, oFont, lDesign )

   METHOD NewBar( oBar, cText, cImgName, bAction, lGroup )

   METHOD Redefine( cId, oWnd, bAction, bValid, bWhen, lUpdate )

   METHOD Click()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD LostFocus()

   METHOD SetText( cText ) INLINE BtnSetText( ::hWnd, cText )

   METHOD GetText() INLINE BtnGetText( ::hWnd )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, cText, oWnd, bAction, nWidth, nHeight, bValid,;
            bWhen, lUpdate, cImgName, oFont, lDesign ) CLASS TButton

   DEFAULT cText := "_Button", oWnd := GetWndDefault(), nWidth := 80,;
           nHeight := 27, lUpdate := .F., lDesign := .F.

   ::bAction   = bAction
   ::hWnd      = CreateButton( cText, cImgName )
   ::bValid    = bValid
   ::bWhen     = bWhen
   ::lUpdate   = lUpdate
   ::lDrag     = lDesign

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow * 10, nCol * 10 )
   ::SetSize( nWidth, nHeight )

   if ! Empty( oFont )
      ::SetFont( oFont )
   endif

   ::Link()

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

      case nMsg == WM_LOSTFOCUS
	   return ::LostFocus()
   endcase

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD LostFocus() CLASS TButton

   if ::bValid != nil
      if ! Eval( ::bValid, Self )
         ::SetFocus()
      endif
   endif

return nil

//----------------------------------------------------------------------------//
