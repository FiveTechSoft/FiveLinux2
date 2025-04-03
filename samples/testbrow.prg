#include "FiveLinux.ch"

REQUEST DBFCDX

function Main()

   local oWnd, oBrw, cTest := Space( 10 )

   USE customer VIA "DBFCDX"

   DEFINE WINDOW oWnd TITLE "Testing Browses" SIZE 522, 400

   @ 4, 2 BROWSE oBrw OF oWnd ;
      HEADERS "First", "Last", "Street", "City", "State", "Zip" ;
      FIELDS  First, Last, Street, City, State, Zip

   oBrw:aColumns[ 1 ]:lBold = .T.
   oBrw:aColumns[ 3 ]:lBold = .T.
   oBrw:aColumns[ 3 ]:nClrPane = { | nRow, lSelected | If( ! lSelected, If( OrdKeyNo() == 3, CLR_WHITE, CLR_CYAN ), CLR_BLUE ) } 
   oBrw:aColumns[ 3 ]:nClrText = { | nRow, lSelected | If( ! lSelected, If( OrdKeyNo() == 3, CLR_RED, CLR_BLUE ), CLR_BLUE ) } 
   oBrw:nClrPane = { | nRow, lSelected | If( ! lSelected, If( OrdKeyNo() % 2 == 0, CLR_HRED, CLR_CYAN ), CLR_BLUE ) } 
   oBrw:nClrText = { | nRow, lSelected | If( ! lSelected, If( OrdKeyNo() % 2 == 0, CLR_MAGENTA, CLR_BLACK ), CLR_WHITE ) } 

   @ 31, 2 BUTTON "_Ok" OF oWnd ACTION oWnd:End()
   @ 31, 12 BUTTON "Bottom" OF oWnd ACTION If( oBrw:oHScroll:lEnabled, oBrw:oHScroll:Disable(), oBrw:oHScroll:Enable() )
   @ 31, 22 BUTTON "Right" OF oWnd ACTION If( oBrw:oVScroll:lEnabled, oBrw:oVScroll:Disable(), oBrw:oVScroll:Enable() )

   ACTIVATE WINDOW oWnd

return nil
