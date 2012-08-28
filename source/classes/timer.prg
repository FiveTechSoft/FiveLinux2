#include "FiveLinux.ch"

static aTimers := {}
static nId     := 1

//----------------------------------------------------------------------------//

CLASS TTimer

   DATA   bAction
   DATA   lActive
   DATA   nId, nInterval
   DATA   Cargo

   METHOD New( nInterval, bAction ) CONSTRUCTOR

   METHOD Activate()

   METHOD DeActivate() INLINE ::lActive := .f., KillTimer( ::nId )

   METHOD End()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nInterval, bAction ) CLASS TTimer

   DEFAULT nInterval := 18, bAction := { || nil }

   ::nInterval = nInterval
   ::bAction   = bAction
   ::nId       = nId++
   ::lActive   = .f.

   AAdd( aTimers, Self )

return Self

//----------------------------------------------------------------------------//

METHOD Activate() CLASS TTimer

   ::nId     = SetTimer( ::nInterval )
   ::lActive = .t.

return nil

//----------------------------------------------------------------------------//

METHOD End() CLASS TTimer

   local nAt

   ::DeActivate()

   if ( nAt := AScan( aTimers, { | o | o == Self } )  ) != 0
      ADel( aTimers, nAt )
      ASize( aTimers, Len( aTimers ) - 1 )
   endif

return nil

//----------------------------------------------------------------------------//

function TimerEvent( nId )

   local nTimer := AScan( aTimers, { | oTimer | oTimer:nId == nId } )

   if nTimer != 0 .and. aTimers[ nTimer ]:lActive
      Eval( aTimers[ nTimer ]:bAction )
   endif

return 0

//----------------------------------------------------------------------------//
