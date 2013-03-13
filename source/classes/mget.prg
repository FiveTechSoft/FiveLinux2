#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TMultiGet FROM TControl

   METHOD New( nRow, nCol, oWnd, bSetGet, nWidth, nHeight, bWhen, bValid,;
               lUpdate )

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD LostFocus()

   METHOD SetText( cText ) INLINE TxtSetText( ::hWnd, cText )

   METHOD GetText() INLINE TxtGetText( ::hWnd )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, oWnd, bSetGet, nWidth, nHeight, bWhen, bValid,;
            lUpdate ) CLASS TMultiGet

   DEFAULT oWnd := GetWndDefault(), nWidth := 224, nHeight := 124,;
           lUpdate := .f.

   ::hWnd    = CreateText()
   ::bSetGet = bSetGet
   ::bWhen   = bWhen
   ::bValid  = bValid
   ::lUpdate = lUpdate

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow * 10, nCol * 10 )
   ::SetSize( nWidth, nHeight )

   ::Link()

   ::SetText( Eval( bSetGet ) )

return Self

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TMultiGet

   do case
      case nMsg == WM_LOSTFOCUS
           ::LostFocus()
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD LostFocus() CLASS TMultiGet

   Eval( ::bSetGet, ::GetText() )

   if ::bValid != nil
      // if Len( ::GetText() ) == 0
      //   ::SetText( " " )
      // endif
      if ! Eval( ::bValid, Self )
         ::SetFocus()
      endif
   endif

   ::oWnd:AEvalWhen()

return nil

//----------------------------------------------------------------------------//
