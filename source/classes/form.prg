#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TForm FROM TWindow

   DATA  oInspector
   DATA  lDesign
   DATA  lCtrlResize INIT .F.

   METHOD Initiate() VIRTUAL

   METHOD MouseMove( nRow, nCol )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol ) CLASS TForm

   local n

   for n = 1 to Len( ::aControls )
      if ::aControls[ n ]:ClassName() != "TSCROLLBAR"
         if nRow >= ::aControls[ n ]:nTop + ::aControls[ n ]:nHeight - 10 .and. ;
            nRow <= ::aControls[ n ]:nTop + ::aControls[ n ]:nHeight + 10 .and. ;
            nCol >= ::aControls[ n ]:nLeft + ::aControls[ n ]:nWidth - 10 .and. ;
            nCol <= ::aControls[ n ]:nLeft + ::aControls[ n ]:nWidth + 10
            CursorSize( ::hWnd )
            exit 
         endif
      endif
   next

   if IsLBtnPressed( ::hWnd ) .and. n <= Len( ::aControls )
      ::aControls[ n ]:SetSize( nCol - ::aControls[ n ]:nLeft,;
                                nRow - ::aControls[ n ]:nTop )
   endif

   if n > Len( ::aControls ) 
      CursorArrow( ::hWnd )
   endif 

return nil 

//----------------------------------------------------------------------------//
