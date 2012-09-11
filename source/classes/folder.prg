#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TFolder FROM TControl

   DATA   aPrompts   // The labels to display on each folder page
   DATA   aDialogs   // An array of dialogboxes, one by each folder page

   CLASSDATA aProperties INIT { "aPrompts", "aDialogs", "cVarName", "nClrText",;
                                "nClrPane", "nTop", "nLeft", "nWidth", "nHeight",;
                                "Cargo", "oMenu", "oFont" }

   METHOD New( nRow, nCol, oWnd, aPrompts, nWidth, nHeight, lUpdate,;
               lDesign, lPixel, cVarName )

   METHOD cGenPrg()

   METHOD SetPrompts( aPrompts )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, oWnd, aPrompts, nWidth, nHeight, lUpdate, lDesign,;
            lPixel, cVarName ) CLASS TFolder

   DEFAULT oWnd := GetWndDefault(), aPrompts := { "_One", "_Two", "T_hree" },;
           lUpdate := .F., nWidth := 288, nHeight := 196, lDesign := .F.,;
           lPixel := .F.

   ::hWnd     = CreateFolder()
   ::aPrompts = aPrompts
   ::lUpdate  = lUpdate
   ::lDrag    = lDesign
   ::cVarName = cVarName

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow * If( lPixel, 1, 10 ), nCol * If( lPixel, 1, 10 ) )
   ::SetSize( nWidth, nHeight )

   ::Link()

   ::SetPrompts()
   ::Show()

return Self

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TFolder

   local cCode := ""
   local cTop, cLeft, cWidth, cHeight
 
   cTop    = LTrim( Str( Int( ::nTop ) ) )
   cLeft   = LTrim( Str( Int( ::nLeft ) ) )
   cWidth  = LTrim( Str( Int( ::nWidth ) ) )
   cHeight = LTrim( Str( Int( ::nHeight ) ) )
 
   cCode += CRLF + "   @ " + cTop + ", " + cLeft + ;
            " FOLDER " + ::cVarName + ' PROMPTS "One", "Two"' + ;
            " ;" + CRLF + '      SIZE ' + cWidth + ", " + cHeight + ;
            " PIXEL OF " + ::oWnd:cVarName + CRLF
 
return cCode

//----------------------------------------------------------------------------//

METHOD SetPrompts( aPrompts ) CLASS TFolder

   local aHandlesPages, n

   if aPrompts != nil
      ::aPrompts = aPrompts
   endif

   aHandlesPages = FldSetPrompts( ::hWnd, ::aPrompts )

   ::aDialogs = Array( Len( aHandlesPages ) )

   for n = 1 to Len( aHandlesPages )
      ::aDialogs[ n ] = TDialog()
      ::aDialogs[ n ]:hWnd = aHandlesPages[ n ]
      ::aDialogs[ n ]:oWnd = Self
   next

return nil

//----------------------------------------------------------------------------//
