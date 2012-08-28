#include "FiveLinux.ch"

REQUEST DBFCDX

function Main()

   local oWnd, oBrw

   USE customer VIA "DBFCDX"

   DEFINE WINDOW oWnd TITLE "Testing Browses" SIZE 522, 317

   @ 2, 2 BROWSE oBrw OF oWnd ;
      HEADERS "First", "Last" ;
      FIELDS  customer->First, customer->Last ;
      SIZE 200, 200 

   USE test VIA "DBFCDX" NEW

   @ 2, 26 BROWSE oBrw OF oWnd ;
      HEADERS "First", "Last" ;
      FIELDS  test->First, test->Last ;
      SIZE 200, 200

   @ 28, 2 BUTTON "_Ok" OF oWnd ACTION oWnd:End()

   ACTIVATE WINDOW oWnd

return nil
