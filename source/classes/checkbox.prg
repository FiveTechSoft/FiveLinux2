#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TCheckBox FROM TControl

   METHOD New( nRow, nCol, cText, oWnd, bSetGet, nWidth, nHeight, bWhen,;
               bValid, lUpdate, lDesign, lPixel, cVarName, bChange )

   METHOD GenLocals()

   METHOD cGenPrg()

   METHOD Click()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD SetCheck( lOnOff ) INLINE CbxSetCheck( ::hWnd, lOnOff )
   METHOD GetCheck() INLINE CbxGetCheck( ::hWnd )

   METHOD SetText( cText ) INLINE BtnSetText( ::hWnd, cText )

   METHOD GetText() INLINE BtnGetText( ::hWnd )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, cText, oWnd, bSetGet, nWidth, nHeight, bWhen,;
            bValid, lUpdate, lDesign, lPixel, cVarName, bChange ) CLASS TCheckBox

   DEFAULT cText := "_Checkbox", oWnd := GetWndDefault(), lUpdate := .f.,;
           nWidth := 80, nHeight := 25, lDesign := .F., lPixel := .F.

   ::bSetGet   = bSetGet
   ::hWnd      = CreateCheckBox( cText )
   ::bWhen     = bWhen
   ::bValid    = bValid
   ::lUpdate   = lUpdate
   ::lDrag     = lDesign
   ::cVarName  = cVarName
   ::bChange   = bChange

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow * If( lPixel, 1, 10 ), nCol * If( lPixel, 1, 10 ) )
   ::SetSize( nWidth, nHeight )

   ::Link()
   ::Show()

   ::SetCheck( Eval( bSetGet ) )

return Self

//----------------------------------------------------------------------------//

METHOD Click() CLASS TCheckBox

   if ::bSetGet != nil
      Eval( ::bSetGet, ::GetCheck() )

      if ! Empty( ::bChange )
         Eval( ::bChange, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//
 
METHOD GenLocals() CLASS TCheckBox
 
return ", " + ::cVarName + ", " + "l" + SubStr( ::cVarName, 2 ) + ;
       " := " + If( ::GetCheck(), ".T.", ".F." )
 
//----------------------------------------------------------------------------//
 
METHOD cGenPRG() CLASS TCheckBox
 
   local cCode := ""
 
   cCode += CRLF + ;
            "   @ " + LTrim( Str( ::nTop ) ) + ", " + ;
            LTrim( Str( ::nLeft ) ) + ;
            " CHECKBOX " + ::cVarName + ;
            " VAR " + "l" + SubStr( ::cVarName, 2 ) + " ;" + CRLF + ;
            '      PROMPT "' + ::GetText() + ;
            " SIZE " + LTrim( Str( ::nWidth ) ) + ", " + ;
                       LTrim( Str( ::nHeight ) ) + ;
            " PIXEL OF " + ::oWnd:cVarName + CRLF
 
return cCode
 
//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TCheckBox

   do case
        case nMsg == WM_CLICK
             return ::Click()
   endcase

return ::Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//
