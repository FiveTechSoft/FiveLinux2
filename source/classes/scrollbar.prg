#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TScrollBar FROM TControl

   DATA   nValue   // The actual value represented in the scrollbar
   DATA   bGoDown  // A codeblock to evaluate when the scrollbar goes down
   DATA   bGoUp    // A codeblock to evaluate when the scrollbar goes up
   DATA   bPos     // A codeblock to evaluate when the scrollbar thumbpos is moved
   DATA   nMax

   METHOD New( nRow, nCol, oWnd, nWidth, nHeight, lVertical, lPixel, bGoDown,;
               bGoUp, bPos )

   METHOD GoBottom() INLINE ::SetValue( ::nMax )

   METHOD GoDown()

   METHOD GoTop() INLINE ::SetValue( 1 )

   METHOD GoUp()

   METHOD ThumbPos( nPos )

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD SetRange( nMin, nMax, nPage ) INLINE ;
          ::nMax := nMax, ScrlSetRange( ::hWnd, nMin, nMax, nPage )

   METHOD GetRange() INLINE ScrlGetRange( ::hWnd )

   METHOD SetValue( nValue ) INLINE ScrlSetValue( ::hWnd, ::nValue := nValue )

   METHOD GetValue() INLINE ScrlGetValue( ::hWnd )

   METHOD ThumbPos( nPos )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, oWnd, nWidth, nHeight, lVertical, lPixel, bGoDown,;
            bGoUp, bPos ) CLASS TScrollBar

   DEFAULT oWnd := GetWndDefault(), lVertical := .t., lPixel := .f.

   if nWidth == nil
      if lVertical
         nWidth  = 16
	 nHeight = 200
      else
         nWidth  = 200
	 nHeight = 16
      endif
   endif

   ::hWnd    = CreateScroll( lVertical )
   ::nValue  = 1
   ::bGoDown = bGoDown
   ::bGoUp   = bGoUp
   ::bPos    = bPos

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow * If( lPixel, 1, 10 ), nCol * If( lPixel, 1, 10 ) )
   ::SetSize( nWidth, nHeight )

   ::Link()

return Self

//----------------------------------------------------------------------------//

METHOD GoDown() CLASS TScrollBar

   if ::bGoDown != nil
      Eval( ::bGoDown, Self )
   endif

   ::nValue = ::GetValue()

return nil

//----------------------------------------------------------------------------//

METHOD GoUp() CLASS TScrollBar

   if ::bGoUp != nil
      Eval( ::bGoUp, Self )
   endif

   ::nValue = ::GetValue()

return nil

//----------------------------------------------------------------------------//

METHOD ThumbPos( nPos ) CLASS TScrollBar

   If ::bPos != nil
      Eval( ::bPos, nPos )
   endif

   ::nValue = nPos

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TScrollBar

   local nValue

   do case
      case nMsg == WM_SCROLL
           nValue = ::GetValue()
           do case
	      case nValue == ::nValue - 1
	           ::GoUp()

	      case nValue == ::nValue + 1
	           ::GoDown()

	      otherwise
                   ::ThumbPos( nValue )
           endcase
   endcase

return nil

//----------------------------------------------------------------------------//
