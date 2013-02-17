#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TListBox FROM TControl

   DATA   aItems   // The array of items displayed at the listbox
   DATA   nAt      // The index of the selected item
   DATA   lInit    // has it been initialized ?

   CLASSDATA aProperties INIT { "aItems", "cVarName", "nClrText",;
                                "nClrPane", "nTop", "nLeft", "nWidth", "nHeight",;
                                "Cargo", "oFont" }

   METHOD New( nRow, nCol, oWnd, bSetGet, aItems, nWidth, nHeight, bWhen,;
               bValid, lUpdate, lDesign, lPixel, cVarName )

   METHOD GenLocals()

   METHOD cGenPrg()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD Change( nIndex ) ;
      INLINE Eval( ::bSetGet, ::aItems[ ::nAt := nIndex ] )

   METHOD SetItems( aItems ) INLINE ::aItems := aItems,;
                                    LbxSetItems( ::hWnd, aItems )

   METHOD SelItem( nItem ) INLINE LbxSelItem( ::hWnd, nItem )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, oWnd, bSetGet, aItems, nWidth, nHeight, bWhen,;
            bValid, lUpdate, lDesign, lPixel, cVarName ) CLASS TListBox

   local cText, nAt

   DEFAULT oWnd := GetWndDefault(), nWidth := 176, nHeight := 160,;
           lUpdate := .F., lDesign := .F., lPixel := .F.

   ::bSetGet  = bSetGet
   ::hWnd     = CreateListBox()
   ::bWhen    = bWhen
   ::bValid   = bValid
   ::lUpdate  = lUpdate
   ::lInit    = .f.
   ::lDrag    = lDesign
   ::cVarName = cVarName

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
   ::SetPos( nRow * If( lPixel, 1, 10 ), nCol * If( lPixel, 1, 10 ) )
   ::SetSize( nWidth, nHeight )

   ::Link()
   ::Show()

return Self

//----------------------------------------------------------------------------//
 
METHOD GenLocals() CLASS TListBox
 
return ", " + ::cVarName + ", " + "c" + SubStr( ::cVarName, 2 )
 
//---------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TListBox
 
   local cCode := ""
   local n
 
   cCode += CRLF + "   @ " + Str( ::nTop, 3 ) + ", " + Str( ::nLeft, 3 ) + ;
            " LISTBOX " + ::cVarName + ;
            " VAR " + "c" + SubStr( ::cVarName, 2 ) + " ITEMS { "
 
   for n = 1 to Len( ::aItems )
      if n > 1
         cCode += ", "
      endif
      cCode += '"' + ::aItems[ n ] + '"'
   next
 
   cCode += " } ;" + CRLF + ;
            "      SIZE " + Str( ::nWidth, 3 ) + ", " + ;
            Str( ::nHeight, 3 ) + " PIXEL OF " + ::oWnd:cVarName + CRLF

return cCode

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

return ::Super:HandleEvent( nMsg, nMsg, nLParam )

//----------------------------------------------------------------------------//
