#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TImage FROM TControl

   DATA   cFileName   // The name of the file that holds the image

   CLASSDATA aProperties INIT { "cFileName", "cVarName", "nClrText",;
                                "nClrPane", "nTop", "nLeft", "nWidth", "nHeight",;
                                "Cargo" }

   METHOD New( nRow, nCol, oWnd, cFileName, nWidth, nHeight, lUpdate, cVarName,;
               lDesign, lPixel )

   METHOD cGenPrg()

   METHOD LoadImage( cFileName )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, oWnd, cFileName, nWidth, nHeight, lUpdate, cVarName,;
            lDesign, lPixel ) CLASS TImage

   DEFAULT oWnd := GetWndDefault(), lUpdate := .F., lDesign := .F.,;
           lPixel := .F.

   ::hWnd    = CreateImage()
   ::lUpdate = lUpdate
   ::lDrag   = lDesign

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow * If( lPixel, 1, 10 ), nCol * If( lPixel, 1, 10 ) )

   ::Link()

   ::LoadImage( cFileName )

   DEFAULT nWidth := ImgGetWidth( ::hWnd ), nHeight := ImgGetHeight( ::hWnd )

   ::SetSize( nWidth, nHeight )

   ::Show()

return Self

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TImage

   local cCode := ""
   local cTop, cLeft, cWidth, cHeight
 
   cTop    = LTrim( Str( Int( ::nTop ) ) )
   cLeft   = LTrim( Str( Int( ::nLeft ) ) )
   cWidth  = LTrim( Str( Int( ::nWidth ) ) )
   cHeight = LTrim( Str( Int( ::nHeight ) ) )
 
   cCode += CRLF + "   @ " + cTop + ", " + cLeft + ;
            " IMAGE " + ::cVarName + ' FILENAME "' + ::cFileName + '"' + ;
            " ;" + CRLF + '      SIZE ' + cWidth + ", " + cHeight + ;
            " PIXEL OF " + ::oWnd:cVarName + CRLF
 
return cCode

//----------------------------------------------------------------------------//

METHOD LoadImage( cFileName ) CLASS TImage

   ::cFileName = cFileName

   ImgLoadFile( ::hWnd, cFileName )

return nil

//----------------------------------------------------------------------------//
