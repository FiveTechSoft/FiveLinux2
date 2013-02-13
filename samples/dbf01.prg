#include "FiveLinux.ch"

function Main()

   local oDbf

   USE customer

   DATABASE oDbf

   MsgInfo( oDbf:First )

   oDbf:Close()

return nil
