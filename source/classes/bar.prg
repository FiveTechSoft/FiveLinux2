#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TBar FROM TControl

   METHOD New( oWnd, nBtnWidth, nBtnHeight )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, nBtnWidth, nBtnHeight ) CLASS TBar

   DEFAULT oWnd := GetWndDefault(), nBtnWidth := 50, nBtnHeight := 50

   ::hWnd = CreateBar( oWnd:hWnd, nBtnWidth, nBtnHeight )

   oWnd:AddControl( Self )

   ::Link()

return Self

//----------------------------------------------------------------------------//
