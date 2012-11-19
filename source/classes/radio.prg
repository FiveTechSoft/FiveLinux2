#include "FiveLinux.ch"

CLASS TRadio FROM TControl

   DATA   oRadMenu   // The TRadMenu container object

   METHOD New( nRow, nCol, oWnd, cText, nWidth, nHeight, oRadMenu, bWhen,;
               bValid, lUpdate )

   METHOD Click()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD lChecked() INLINE RadChecked( ::hWnd )

   METHOD SetCheck( lOnOff ) INLINE RadSetCheck( ::hWnd, lOnOff )

   METHOD SetText( cText ) INLINE BtnSetText( ::hWnd, cText )

   METHOD GetText() INLINE BtnGetText( ::hWnd )

ENDCLASS

METHOD New( nRow, nCol, oWnd, cText, nWidth, nHeight, oRadMenu, bWhen,;
            bValid, lUpdate ) CLASS TRadio

   local hGroup := oRadMenu:hGroup

   DEFAULT oWnd := GetWndDefault(), nWidth := 100, nHeight := 23,;
           lUpdate := .f.

   ::hWnd = CreateRadio( cText, @hGroup )
   ::oRadMenu = oRadMenu
   ::bWhen    = bWhen
   ::bValid   = bValid
   ::lUpdate  = lUpdate

   oRadMenu:hGroup = hGroup

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow * 10, nCol * 10 )
   ::SetSize( nWidth, nHeight )

   ::Link()

return Self

METHOD Click() CLASS TRadio

   local nAt := AScan( ::oRadMenu:aItems, { | oRadio | oRadio:hWnd == ::hWnd } )

   if ::lChecked .and. nAt != 0
      Eval( ::oRadMenu:bSetGet, nAt )
   endif

return nil

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TRadio

   do case
      case nMsg == WM_CLICK
           ::Click()
   endcase

return nil
