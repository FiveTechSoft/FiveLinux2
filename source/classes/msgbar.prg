#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TMsgBar FROM TControl

   DATA   cMsg   // The msgbar shown text

   METHOD New( oWnd, cMsg, lUpdate )

   METHOD SetText( cText ) INLINE SetMsgBarText( ::hWnd, 1, cText )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, cMsg, lUpdate ) CLASS TMsgBar

   DEFAULT oWnd := GetWndDefault(), cMsg := "", lUpdate := .f.

   ::hWnd = CreateMsgBar( oWnd:hWnd )
   ::cMsg = cMsg
   ::lUpdate = lUpdate

   oWnd:AddControl( Self )
   oWnd:oMsgBar = Self

   ::Link()

   ::SetText( cMsg )

return Self

//----------------------------------------------------------------------------//
