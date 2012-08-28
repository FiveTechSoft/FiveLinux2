#include "FiveLinux.ch"

CLASS TRadMenu

   DATA   aItems   // An array with all the managed TRadio controls objects
   DATA   bSetGet  // A bSetGet codeblock to manage a related variable value
   DATA   bChange  // A codeblock to evaluate when a radio item is selected
   DATA   hGroup   // An internal handle of the radios group
   DATA   lUpdate  // Update the control contents if its container is updated

   METHOD New( nRow, nCol, oWnd, bSetGet, acItems, nWidth, nHeight, bWhen,;
               bvalid, lUpdate )

ENDCLASS

METHOD New( nRow, nCol, oWnd, bSetGet, acItems, nWidth, nHeight, bWhen,;
            bValid, lUpdate ) CLASS TRadMenu

   local n, hGroup := 0

   DEFAULT oWnd := GetWndDefault(), nWidth := 100, nHeight := 23,;
           lUpdate := .f.

   ::bSetGet = bSetGet
   ::aItems  = {}
   ::hGroup  = 0
   ::lUpdate = lUpdate

   for n = 1 to Len( acItems )
      AAdd( ::aItems, TRadio():New( nRow, nCol, oWnd, acItems[ n ],;
                                    nWidth, nHeight, Self, bWhen, bValid,;
				    lUpdate ) )
      nRow += 2.5
   next

   n = Eval( bSetGet )
   if ValType( n ) != "N"
      Eval( bSetGet, 1 )
      n = 1
   endif
   if n > 0 .and. n <= Len( acItems )
      ::aItems[ n ]:SetCheck( .t. )
   endif

return Self
