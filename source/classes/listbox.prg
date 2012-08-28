#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TListBox FROM TControl

   DATA   aItems   // The array of items displayed at the listbox
   DATA   nAt      // The index of the selected item
   DATA   lInit    // has it been initialized ?

   METHOD New( nRow, nCol, oWnd, bSetGet, aItems, nWidth, nHeight, bWhen,;
               bValid, lUpdate )

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD Change( nIndex ) ;
      INLINE Eval( ::bSetGet, ::aItems[ ::nAt := nIndex ] )

   METHOD SetItems( aItems ) INLINE ::aItems := aItems,;
                                    LbxSetItems( ::hWnd, aItems )

   METHOD SelItem( nItem ) INLINE LbxSelItem( ::hWnd, nItem )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, oWnd, bSetGet, aItems, nWidth, nHeight, bWhen,;
            bValid, lUpdate ) CLASS TListBox

   local cText, nAt

   DEFAULT oWnd := GetWndDefault(), nWidth := 176, nHeight := 160,;
           lUpdate := .f.

   ::bSetGet = bSetGet
   ::hWnd    = CreateListBox()
   ::bWhen   = bWhen
   ::bValid  = bValid
   ::lUpdate = lUpdate
   ::lInit   = .f.

   if ValType( cText := Eval( bSetGet ) ) == "C" .and. ;
      ( nAt := AScan( aItems, cText ) ) != 0
      ::nAt = nAt
   else
      ::nAt = 1
   endif

   ::SetItems( aItems )
   ::SelItem( ::nAt )

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow * 10, nCol * 10 )
   ::SetSize( nWidth, nHeight )

   ::Link()

return Self

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TListBox

   if ! ::lInit
      ::lInit = .t.
      return nil
   endif

   do case
        case nMsg == WM_CHANGE
             return ::Change( nWParam )
   endcase

return nil

//----------------------------------------------------------------------------//
