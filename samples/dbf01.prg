#include "FiveLinux.ch"

function Main()

   local oDbf

   USE customer

   DATABASE oDbf

   MsgInfo( oDbf:First )
   MsgInfo( oDbf:Last )

   oDbf:Close()

return nil
