static aMenus := {}

function MenuBegin( lPopup )

   if Len( aMenus ) > 0
      lPopup = .t.
   endif

   AAdd( aMenus, TMenu():New( lPopup ) )

return ATail( aMenus )

function MenuAddItem( cPrompt, bAction, cResName )

   ATail( aMenus ):Add( TMenuItem():New( cPrompt, bAction, cResName ) )

return nil

function MenuEnd()

   local oPopup

   if Len( aMenus ) > 1
      oPopup = ATail( aMenus )
   endif

   ASize( aMenus, Len( aMenus ) - 1 )

   if oPopup != nil
      ATail( ATail( aMenus ):aItems ):Add( oPopup )
   endif

return nil
