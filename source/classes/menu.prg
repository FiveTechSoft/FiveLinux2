#include "FiveLinux.ch"

CLASS TMenu

   DATA   hMenu    // An internal handle of the menu
   DATA   aItems   // An array with the menuitems

   METHOD New( lPopup )

   METHOD Activate( nRow, nCol, oWnd )

   METHOD Add( oMenuItem )

   METHOD Command( nID )

   METHOD SelItem( nPos ) INLINE MenuSelItem( ::hMenu, ::aItems[ nPos ]:hMenuItem )

ENDCLASS

METHOD New( lPopup ) CLASS TMenu

   DEFAULT lPopup := .f.

   if ! lPopup
      ::hMenu = CreateMenu()
   else
      ::hMenu = CreatePopup()
   endif

   ::aItems  = {}

return Self

METHOD Activate( nRow, nCol, oWnd ) CLASS TMenu

   local n

   for n = 1 to Len( ::aItems )
      MenuShowItem( ::aItems[ n ]:hMenuItem )
   next

   SetMenuProp( Self, GetProp( oWnd:hWnd, "WP" ) )
   oWnd:oPopup = Self

   MenuShowPopup( ::hMenu )

return nil

METHOD Add( oMenuItem ) CLASS TMenu

   AAdd( ::aItems, oMenuItem )
   oMenuItem:hMenuItem = AppendMenu( ::hMenu, oMenuItem:cPrompt,;
   				     oMenuItem:cResName )

return nil

METHOD Command( nID ) CLASS TMenu

   local oMenuItem := FindMenuItem( Self, nID )

   if oMenuItem != nil .and. oMenuItem:bAction != nil
      Eval( oMenuItem:bAction, oMenuItem )
   endif

return nil

static function FindMenuItem( oMenu, nID )

   local n, oItem

   for n = 1 to Len( oMenu:aItems )
      if oMenu:aItems[ n ]:oPopup == nil
         if oMenu:aItems[ n ]:hMenuItem == nID
	    return oMenu:aItems[ n ]
	 endif
      else
         if ( oItem := FindMenuItem( oMenu:aItems[ n ]:oPopup, nID ) ) != nil
	    return oItem
	 endif
      endif
   next

return nil

function SetMenuProp( oMenu, nAt )

   local n

   for n = 1 to Len( oMenu:aItems )
      if oMenu:aItems[ n ]:oPopup == nil
         SetProp( oMenu:aItems[ n ]:hMenuItem, "WP", nAt )
      else
         SetMenuProp( oMenu:aItems[ n ]:oPopup, nAt )
      endif
   next

return nil
