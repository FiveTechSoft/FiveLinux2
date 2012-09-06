#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TForm FROM TWindow

   DATA  oInspector
   DATA  lDesign

   METHOD Initiate() VIRTUAL

   METHOD MouseMove( nRow, nCol )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol ) CLASS TForm

   local n

   for n = 1 to Len( ::aControls )
      if ::aControls[ n ]:ClassName() != "TSCROLLBAR"
         if nRow >= ::aControls[ n ]:nTop + ::aControls[ n ]:nHeight .and. ;
            nRow <= ::aControls[ n ]:nTop + ::aControls[ n ]:nHeight + 5 .and. ;
            nCol >= ::aControls[ n ]:nLeft + ::aControls[ n ]:nWidth .and. ;
            nCol <= ::aControls[ n ]:nLeft + ::aControls[ n ]:nWidth + 5
            CursorSize( ::hWnd )
            exit
         else
            CursorArrow( ::hWnd )
         endif
      endif
   next

return nil 

//----------------------------------------------------------------------------//
