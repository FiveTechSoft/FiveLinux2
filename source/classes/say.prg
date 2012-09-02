#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TSay FROM TControl

   METHOD New( nRow, nCol, oWnd, cText, nWidth, nHeight, lUpdate, oFont,;
               lPixel, lDesign, cVarName )

   METHOD cGenPrg()

   METHOD SetText( cText ) INLINE SaySetText( ::hWnd, cText )

   METHOD GetText() INLINE SayGetText( ::hWnd )

   METHOD SetJustify( nType ) INLINE SaySetJustify( ::hWnd, nType ) // LEFT = 0, RIGHT = 1, CENTER = 2, FILL = 3

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, oWnd, cText, nWidth, nHeight, lUpdate, oFont,;
            lPixel, lDesign, cVarName ) CLASS TSay

   DEFAULT oWnd := GetWndDefault(), nWidth := 70, nHeight := 20,;
           lUpdate := .f., lPixel := .F., lDesign := .F.

   ::hWnd     = CreateSay( cText )
   ::lUpdate  = lUpdate
   ::lDrag    = lDesign
   ::cVarName = cVarName

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
 
METHOD cGenPrg() CLASS TSay 
 
   local cCode := CRLF + "   @ " + Str( ::nTop, 3 ) + ", " + ; 
                  Str( ::nLeft, 3 ) + " SAY " + ::cVarName + ;
                  ' PROMPT "' + ::GetText() + '"' + ; 
                  ' SIZE ' + Str( ::nWidth, 3 ) + ", " + ; 
                  Str( ::nHeight, 3 ) + " PIXEL OF " + ::oWnd:cVarName + CRLF 
return cCode 
 
//----------------------------------------------------------------------------// 
