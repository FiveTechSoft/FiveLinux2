#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TImage FROM TControl

   DATA   cFileName   // The name of the file that holds the image

   METHOD New( nRow, nCol, oWnd, cFileName, nWidth, nHeight, lUpdate )

   METHOD LoadImage( cFileName )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, oWnd, cFileName, nWidth, nHeight, lUpdate ) ;
   CLASS TImage

   DEFAULT oWnd := GetWndDefault(), lUpdate := .f.

   ::hWnd = CreateImage()
   ::lUpdate = lUpdate

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( ::hWnd, nRow * 10, nCol * 10 )

   ::Link()

   ::LoadImage( cFileName )

   DEFAULT nWidth := ImgGetWidth( ::hWnd ), nHeight := ImgGetHeight( ::hWnd )

   ::SetSize( nWidth, nHeight )

   ::Show()

return Self

//----------------------------------------------------------------------------//

METHOD LoadImage( cFileName ) CLASS TImage

   ::cFileName = cFileName

   ImgLoadFile( ::hWnd, cFileName )

return nil

//----------------------------------------------------------------------------//
