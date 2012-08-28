// Test

#include "hbclass.ch"

function Main()

   MsgInfo( ValType( @Test_One() ) )

return nil

CLASS Test

   METHOD One

ENDCLASS

METHOD One CLASS Test

return nil
