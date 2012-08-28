#include "FiveLinux.ch"

CLASS TGroup FROM TControl

   METHOD New( nRow, nCol, oWnd, cText, nWidth, nHeight, lUpdate )

   METHOD SetText( cText ) INLINE GrpSetText( ::hWnd, cText )

   METHOD GetText() INLINE GrpGetText( ::hWnd )

ENDCLASS

METHOD New( nRow, nCol, oWnd, cText, nWidth, nHeight, lUpdate ) CLASS TGroup

   DEFAULT oWnd := GetWndDefault(), cText := "_Group", nWidth := 190,;
           nHeight := 130, lUpdate := .f.

   ::hWnd = CreateGroup( cText )
   ::lUpdate = lUpdate

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   SetCoors( ::hWnd, nRow * 10, nCol * 10 )
   SetSize( ::hWnd, nWidth, nHeight )

   ::Link()

return Self
