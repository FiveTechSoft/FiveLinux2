#include "FiveLinux.ch"

function Main()

   local oDlg, oMeter, nVal := 0

   DEFINE DIALOG oDlg SIZE 600, 400 TITLE "Testing a Meter"
   
   oDlg:bStart := { || Index( oMeter ) }

   @ 18, 8 METER oMeter VAR nVal TOTAL 100 OF oDlg SIZE 440, 25
   
   @ 28, 24 BUTTON "Ok" OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return nil

function Index( oMeter )

   for n = 1 to 100
      oMeter:Set( n )
      SysRefresh()
   next
   
return nil    