#include "FiveLinux.ch"

function Main()

   local oWnd, oTmr

   DEFINE WINDOW oWnd TITLE "Testing timers"

   DEFINE TIMER oTmr INTERVAL 200 ACTION oWnd:SetText( Time() )

   ACTIVATE TIMER oTmr

   ACTIVATE WINDOW oWnd

return nil
