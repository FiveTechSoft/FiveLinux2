#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TCheckBox FROM TControl

   METHOD New( nRow, nCol, cText, oWnd, bSetGet, nWidth, nHeight, bWhen,;
               bValid, lUpdate )

   METHOD Click()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD SetCheck( lOnOff ) INLINE CbxSetCheck( ::hWnd, lOnOff )
   METHOD GetCheck() INLINE CbxGetCheck( ::hWnd )

   METHOD SetText( cText ) INLINE BtnSetText( ::hWnd, cText )

   METHOD GetText() INLINE BtnGetText( ::hWnd )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, cText, oWnd, bSetGet, nWidth, nHeight, bWhen,;
            bValid, lUpdate ) CLASS TCheckBox

   DEFAULT cText := "_Checkbox", oWnd := GetWndDefault(), lUpdate := .f.,;
           nWidth := 80, nHeight := 25

   ::bSetGet   = bSetGet
   ::hWnd      = CreateCheckBox( cText )
   ::bWhen     = bWhen
   ::bValid    = bValid
   ::lUpdate   = lUpdate

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow * 10, nCol * 10 )
   ::SetSize( nWidth, nHeight )

   ::Link()
   ::Show()

   ::SetCheck( Eval( bSetGet ) )

return Self

//----------------------------------------------------------------------------//

METHOD Click() CLASS TCheckBox

   if ::bSetGet != nil
      Eval( ::bSetGet, ::GetCheck() )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TCheckBox

   do case
        case nMsg == WM_CLICK
             return ::Click()

	case nMsg == WM_LOSTFOCUS
	     return ::LostFocus()     
   endcase

return nil

//----------------------------------------------------------------------------//
