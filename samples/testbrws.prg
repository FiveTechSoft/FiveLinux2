// Selecting multiple elements from a browse

#include "FiveLinux.ch"

function Main()

   local oWnd, oBrw, aTest := { { .F., "one", "two" }, { .F., "three", "four" }, { .F., "five", "six" } }

   DEFINE WINDOW oWnd TITLE "Testing Browses" SIZE 522, 317

   @ 2, 2 BROWSE oBrw OF oWnd ;
      HEADERS "Selected", "First", "Second" ;
      FIELDS  If( aTest[ oBrw:nAt ][ 1 ], "X", " " ), aTest[ oBrw:nAt ][ 2 ], aTest[ oBrw:nAt ][ 3 ]

   oBrw:SetArray( aTest )
   oBrw:nRowPos = 2
   oBrw:nAt = 2

   oBrw:bKeyDown = { | nKey | If( nKey == 32, ( aTest[ oBrw:nAt ][ 1 ] := ! aTest[ oBrw:nAt ][ 1 ], oBrw:Refresh() ),) }

   oBrw:bLClicked = { | nRowAt, nCol | If( nCol < 80, ( aTest[ oBrw:nAt ][ 1 ]:= ! aTest[ oBrw:nAt ][ 1 ], oBrw:Refresh() ),) }   

   oBrw:aColumns[ 1 ]:nClrPane = RGB( 90, 0, 0 )
   oBrw:aColumns[ 2 ]:nClrPane = RGB( 90, 0, 0 )
   oBrw:aColumns[ 3 ]:nClrPane = { | nRow, lSelected | ;
      If( ! lSelected, If( oBrw:nAt == 3, RGB( 128, 0, 128 ), RGB( 0, 128, 0 ) ),;
          RGB( 0, 0, 128 ) ) }
   // oBrw:aColumns[ 3 ]:nClrText = { | nRow, lSelected | If( ! lSelected, If( OrdKeyNo() == 3, CLR_RED, CLR_BLUE ), CLR_BLUE ) } 
   // oBrw:nClrPane = { | nRow, lSelected | If( ! lSelected, If( OrdKeyNo() % 2 == 0, CLR_HRED, CLR_CYAN ), CLR_BLUE ) } 
   // oBrw:nClrText = { | nRow, lSelected | If( ! lSelected, If( OrdKeyNo() % 2 == 0, CLR_MAGENTA, CLR_BLACK ), CLR_WHITE ) }

   @ 28, 2 BUTTON "_Ok" OF oWnd ACTION oWnd:End()
   
   @ 28, 30 BUTTON "Add" OF oWnd ACTION ( AAdd( aTest, { .F., "five", "six" } ), oBrw:SetArray( aTest ), oBrw:GoTop(), oBrw:Refresh() )

   @ 28, 40 BUTTON "Select" OF oWnd ACTION ( aTest[ oBrw:nRowPos ][ 1 ] := ! aTest[ oBrw:nRowPos ][ 1 ], oBrw:Refresh() )

   oWnd:Center()

   ACTIVATE WINDOW oWnd 

return nil
 
