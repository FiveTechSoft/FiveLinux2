#include "FiveLinux.ch"

CLASS TFolder FROM TControl

   DATA   aPrompts   // The labels to display on each folder page
   DATA   aDialogs   // An array of dialogboxes, one by each folder page

   METHOD New( nRow, nCol, oWnd, aPrompts, nWidth, nHeight, lUpdate )

   METHOD SetPrompts( aPrompts )

ENDCLASS

METHOD New( nRow, nCol, oWnd, aPrompts, nWidth, nHeight, lUpdate ) ;
   CLASS TFolder

   DEFAULT oWnd := GetWndDefault(), aPrompts := { "_One", "_Two", "T_hree" },;
           lUpdate := .f., nWidth := 288, nHeight := 196

   ::hWnd     = CreateFolder()
   ::aPrompts = aPrompts
   ::lUpdate  = lUpdate

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   SetCoors( ::hWnd, nRow * 10, nCol * 10 )
   SetSize( ::hWnd, nWidth, nHeight )

   ::Link()

   ::SetPrompts()

return Self

METHOD SetPrompts( aPrompts ) CLASS TFolder

   local aHandlesPages, n

   if aPrompts != nil
      ::aPrompts = aPrompts
   endif

   aHandlesPages = FldSetPrompts( ::hWnd, ::aPrompts )

   ::aDialogs = Array( Len( aHandlesPages ) )

   for n = 1 to Len( aHandlesPages )
      ::aDialogs[ n ] = TDialog()
      ::aDialogs[ n ]:hWnd = aHandlesPages[ n ]
   next

return nil
