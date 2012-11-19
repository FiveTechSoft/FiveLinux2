// Using a browse to display a multidimensional array

#include "FiveLinux.ch"

function Main()

   local oWnd, oBrw, aTest := { { .F., "one", "two" }, { .F., "three", "four" }, { .F., "five", "six" } }

   DEFINE WINDOW oWnd TITLE "Testing Browses" SIZE 522, 317

   @ 2, 2 BROWSE oBrw OF oWnd ;
      HEADERS "Selected", "First", "Second" ;
      FIELDS  If( aTest[ oBrw:nArrayAt ][ 1 ], "X", " " ), aTest[ oBrw:nArrayAt ][ 2 ], aTest[ oBrw:nArrayAt ][ 3 ]

   oBrw:SetArray( aTest )
   oBrw:nRowPos = 2
   oBrw:nArrayAt = 2

   oBrw:bKeyDown = { | nKey | If( nKey == 32, ( aTest[ oBrw:nRowPos ][ 1 ] := ! aTest[ oBrw:nRowPos ][ 1 ], oBrw:Refresh() ),) }
   oBrw:bLClicked = { | nRowAt, nCol | If( nCol < 80, ( aTest[ oBrw:nRowPos ][ 1 ] := ! aTest[ oBrw:nRowPos ][ 1 ], oBrw:Refresh() ),) }

   @ 28, 2 BUTTON "_Ok" OF oWnd ACTION oWnd:End()
   
   @ 28, 30 BUTTON "Add" OF oWnd ACTION ( AAdd( aTest, { .F., "five", "six" } ), oBrw:SetArray( aTest ), oBrw:GoTop(), oBrw:Refresh() )

   @ 28, 40 BUTTON "Select" OF oWnd ACTION ( aTest[ oBrw:nRowPos ][ 1 ] := ! aTest[ oBrw:nRowPos ][ 1 ], oBrw:Refresh() )

   ACTIVATE WINDOW oWnd 

return nil
