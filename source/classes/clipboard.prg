#include "FiveLinux.ch"

CLASS TClipboard

   DATA   hClipboard   // An internal handle of the clipboard

   METHOD New()

   METHOD Clear() INLINE ClpClear( ::hClipboard )

   METHOD SetText( cText ) INLINE ClpSetText( ::hClipboard, cText )

   METHOD GetText() INLINE ClpGetText( ::hClipboard )

ENDCLASS

METHOD New() CLASS TClipboard

   ::hClipboard = CreateClipboard()

return Self
