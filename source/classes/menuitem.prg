#include "FiveLinux.ch"

CLASS TMenuItem

   DATA   hMenuItem   // An internal handle of the menuitem
   DATA   cPrompt     // The menuitem text
   DATA   oPopup      // A contained popup menu
   DATA   bAction     // The action to execute when the menuitem is selcted
   DATA   cResName    // The GTK resource name 

   METHOD New( cPrompt, bAction, cResName )
   METHOD Add( oPopup )

ENDCLASS

METHOD New( cPrompt, bAction, cResName ) CLASS TMenuItem

   ::cPrompt  = cPrompt
   ::bAction  = bAction
   ::cResName = cResName

return Self

METHOD Add( oPopup ) CLASS TMenuItem

   ::oPopup = oPopup

   AddPopup( ::hMenuItem, oPopup:hMenu )

return nil
