#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TProgress FROM TControl

   DATA   nTotal   // The total amount represented by the progress bar

   METHOD New( nRow, nCol, oWnd, bSetGet, nTotal, nWidth, nHeight, lUpdate )

   METHOD Set( nValue ) INLINE ProSet( ::hWnd, nValue / ::nTotal )

   METHOD SetText( cText ) INLINE ProSetText( ::hWnd, cText )

   METHOD SetTotal( nTotal ) INLINE ::nTotal := nTotal,;
                                    ::Set( Eval( ::bSetGet ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, oWnd, bSetGet, nTotal, nWidth, nHeight, lUpdate ) ;
   CLASS TProgress

   DEFAULT oWnd := GetWndDefault(), lUpdate := .f., nWidth := 160,;
           nHeight := 24

   ::bSetGet = bSetGet
   ::hWnd    = CreateProgress()
   ::nTotal  = nTotal
   ::lUpdate = lUpdate

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow * 10, nCol * 10 )
   ::SetSize( nWidth, nHeight )

   ::Link()
   ::Show()

   ::Set( Eval( bSetGet ) )

return Self

//----------------------------------------------------------------------------//
