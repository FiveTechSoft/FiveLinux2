#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TSay FROM TControl

   METHOD New( nRow, nCol, oWnd, cText, nWidth, nHeight, lUpdate, oFont )

   METHOD SetText( cText ) INLINE SaySetText( ::hWnd, cText )

   METHOD GetText() INLINE SayGetText( ::hWnd )

   METHOD SetJustify( nType ) INLINE SaySetJustify( ::hWnd, nType ) // LEFT = 0, RIGHT = 1, CENTER = 2, FILL = 3

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, oWnd, cText, nWidth, nHeight, lUpdate, oFont ) CLASS TSay

   DEFAULT oWnd := GetWndDefault(), nWidth := 70, nHeight := 20,;
           lUpdate := .f.

   ::hWnd    = CreateSay( cText )
   ::lUpdate = lUpdate

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow * 10, nCol * 10 )
   ::SetSize( nWidth, nHeight )

   if oFont != nil
      ::SetFont( oFont )
   endif

   ::Link()

return Self

//----------------------------------------------------------------------------//
