#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TSay FROM TControl

   METHOD New( nRow, nCol, oWnd, cText, nWidth, nHeight, lUpdate, oFont,;
               lPixel, lDesign )

   METHOD SetText( cText ) INLINE SaySetText( ::hWnd, cText )

   METHOD GetText() INLINE SayGetText( ::hWnd )

   METHOD SetJustify( nType ) INLINE SaySetJustify( ::hWnd, nType ) // LEFT = 0, RIGHT = 1, CENTER = 2, FILL = 3

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, oWnd, cText, nWidth, nHeight, lUpdate, oFont,;
            lPixel, lDesign ) CLASS TSay

   DEFAULT oWnd := GetWndDefault(), nWidth := 70, nHeight := 20,;
           lUpdate := .f., lPixel := .F., lDesign := .F.

   ::hWnd    = CreateSay( cText )
   ::lUpdate = lUpdate
   ::lDrag   = lDesign

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow * If( lPixel, 1, 10 ), nCol * If( lPixel, 1, 10 ) )
   ::SetSize( nWidth, nHeight )

   if oFont != nil
      ::SetFont( oFont )
   endif

   ::Link()
   ::Show()

return Self

//----------------------------------------------------------------------------//
