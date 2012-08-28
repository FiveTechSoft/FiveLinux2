// Testing FiveLinux errorsys

#include "FiveLinux.ch"

function Main()

   MsgInfo( "before the error" )

   Another( "test" )

return nil

function Another( c )

   x++  // Here we generate an error

return nil
