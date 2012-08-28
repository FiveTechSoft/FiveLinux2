#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

function aGetWorkAreas()     // Returns an Array with all available Alias

   local aAreas := {}
   local n

   for n = 1 to 255
      if ! Empty( Alias( n ) )
         AAdd( aAreas, Alias( n ) )
      endif
   next

return aAreas

//----------------------------------------------------------------------------//

function cGetNewAlias( cAlias ) // returns a new alias name for
                                // an alias
   local cNewAlias, nArea := 1

   if Select( cAlias ) != 0
      while Select( cNewAlias := ( cAlias + ;
            StrZero( nArea++, 3 ) ) ) != 0
      end
   else
      cNewAlias = cAlias
   endif

return cNewAlias

//----------------------------------------------------------------------------//

function GetOrdNames()   // returns an array with all index TAGs names

   local aNames := {}
   local n := 1

   while ! Empty( OrdName( n ) )
      AAdd( aNames, StrCapFirst( OrdName( n++ ) ) )
   end

return aNames

//----------------------------------------------------------------------------//

function StrCapFirst( cText )

return Upper( Left( cText, 1 ) ) + Lower( SubStr( cText, 2 ) )

//----------------------------------------------------------------------------//

function DupRecord() // duplicates current record

   local aRecord := Array( FCount() )
   local n

   for n = 1 to Len( aRecord )
      aRecord[ n ] = FieldGet( n )
   next

   APPEND BLANK

   if RLock()
      for n = 1 to Len( aRecord )
         FieldPut( n, aRecord[ n ] )
      next
      DbUnLock()
   else
      MsgInfo( "Record in use", "Please, try again" )
   endif

return nil

//----------------------------------------------------------------------------//
