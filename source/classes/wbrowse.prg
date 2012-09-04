#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TWBrowse FROM TControl

   DATA   aColumns   // An array of column objects
   DATA   cAlias     // The alias of a used workarea
   DATA   bSkip      // A codeblock performed to skip n rows
   DATA   bGoTop     // A codeblock to evaluate to go to the top
   DATA   bGoBottom  // A codeblock to evaluate to go to the bottom
   DATA   bLogicLen  // A codeblock to get the virtual rows amount
   DATA   lHitTop    // If the top most row has been reached
   DATA   lHitBottom // If the bottom most row has been reached
   DATA   nRowPos    // The selected row from the visible ones
   DATA   nColPos    // The left most visible column
   DATA   nLen       // The value returned by bLogicLen 
   DATA   oVScroll   // The related vertical scrollbar object
   DATA   oHScroll   // The related horizontal scrollbar object
   DATA   lSetVRange // checks if the vertical scrollbar has been initialized
   DATA   nAt          // array current position

   METHOD New( nRow, nCol, oWnd, aHeaders, aColSizes, abFields, cAlias,;
               nWidth, nHeight, lUpdate, bChange, bLDblClick, lDesign, lPixel,;
               cVarName )

   METHOD AddCol( bData, cHeader, nSize ) 

   METHOD AddColumn( oCol ) INLINE AAdd( ::aColumns, oCol ), ::oHScroll:SetRange( 1, Len( ::aColumns ) )

   METHOD cGenPrg() 

   METHOD DrawHeaders( nPEvent )

   METHOD DrawLine( nRow, lSelected )

   METHOD DrawLines()

   METHOD DrawRows()

   METHOD DrawSelect() INLINE ::DrawLine( ::nRowPos, .t. )

   METHOD GoBottom()

   METHOD GoDown()

   METHOD GoLeft()

   METHOD GoRight()

   METHOD GoTop()

   METHOD GoTo( nPos )

   METHOD GoUp()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD KeyDown( nKey )

   METHOD LButtonDown( nRow, nCol )

   METHOD MouseMove( nRow, nCol )

   METHOD nRowCount() INLINE BrwRowCount( ::hWnd )

   METHOD PageDown( nLines )

   METHOD PageUp( nLines )

   METHOD Paint( nPEvent )

   METHOD SetSize( nWidth, nHeight )

   METHOD RButtonDown( nRow, nCol ) VIRTUAL

   METHOD Skip( n )

   METHOD SetAltColors( nClrText, nClrPane, nClrTextS, nClrPaneS )

   METHOD SetArray( aArray )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, oWnd, aHeaders, aColSizes, abFields, cAlias, nWidth,;
            nHeight, lUpdate, bChange, bLDblClick, lDesign, lPixel, cVarName ) CLASS TWBrowse

   local n

   DEFAULT cAlias := Alias(), nWidth := 460, nHeight := 240, lUpdate := .f.,;
           oWnd := GetWndDefault(), lPixel := .F., lDesign := .F.

   ::hWnd       = CreateBrowse()
   ::aColumns   = {}
   ::cAlias     = cAlias
   ::lHitTop    = .F.
   ::lHitBottom = .F.
   ::nRowPos    = 1
   ::nColPos    = 1
   ::lSetVRange = .F.
   ::lDrag      = lDesign
   ::cVarName   = cVarName

   if ! Empty( cAlias )
      ::bGoBottom  = { || ( ::cAlias )->( DbGoBottom() ) }
      ::bGoTop     = { || ( ::cAlias )->( DbGoTop() ) }
      ::bLogicLen  = { || ( ::cAlias )->( RecCount() ) }
   else
      ::bLogicLen = { || 1 }
   endif

   ::lUpdate    = lUpdate
   ::bChange    = bChange
   ::bLDblClick = bLDblClick

   oWnd:AddControl( Self )

   SetParent( ::hWnd, oWnd:hWnd )
   ::SetPos( nRow := ( nRow * If( lPixel, 1, 10 ) ), nCol := ( nCol * If( lPixel, 1, 10 ) ) )
   ::SetSize( nWidth, nHeight )

   ::Link()
   ::Show()

   if Empty( aHeaders )
      aHeaders = GetFieldNames()
   endif

   if aHeaders != nil
      for n = 1 to Len( aHeaders )
         AAdd( ::aColumns, TWBColumn():New( aHeaders[ n ] ) )
	 if ! Empty( abFields )
	    ATail( ::aColumns ):bBlock = abFields[ n ]
	 else
            ATail( ::aColumns ):bBlock = GetFieldBlock( ::cAlias, n ) 
         endif
	 if aColSizes != nil
	    ATail( ::aColumns ):nWidth = aColSizes[ n ]
	 endif
      next
   endif

   @ nRow, nCol + nWidth + 2 SCROLLBAR ::oVScroll OF oWnd ;
      SIZE 16, nHeight PIXEL ON DOWN ::GoDown() ON UP ::GoUp() ;
      ON THUMBPOS If( ::cAlias == "ARRAY", If( ::nAt != nPos, ::GoTo( nPos ), ),;
                  If( ( ::cAlias )->( OrdKeyNo() ) != nPos, ::GoTo( nPos ),) ) 

   if ! Empty( cAlias )
      ::oVScroll:SetRange( 1, ( cAlias )->( OrdKeyCount() ) )
      ::oVScroll:SetValue( ( cAlias )->( RecNo() ) )
   endif

   @ nRow + nHeight + 2, nCol SCROLLBAR ::oHScroll HORIZONTAL OF oWnd ;
      SIZE nWidth, 16 PIXEL ON DOWN ::GoRight() ON UP ::GoLeft()

   ::oHScroll:SetRange( 1, Len( ::aColumns ) )

return Self

//----------------------------------------------------------------------------//

static function GetFieldBlock( cAlias, n )

return { || ( cAlias )->( FieldGet( n ) ) }

//----------------------------------------------------------------------------//

METHOD AddCol( bData, cHeader, nSize ) CLASS TWBrowse

   local oCol 

   AAdd( ::aColumns, oCol := TWBColumn():New( cHeader ) )
   oCol:bBlock = bData
   oCol:nWidth = nSize

   ::oHScroll:SetRange( 1, Len( ::aColumns ) )

return oCol

//----------------------------------------------------------------------------//

METHOD cGenPrg() CLASS TWBrowse

   local cCode := "" 
   local cTop, cLeft, cWidth, cHeight
 
   cTop    = LTrim( Str( Int( ::nTop ) ) )
   cLeft   = LTrim( Str( Int( ::nLeft ) ) )
   cWidth  = LTrim( Str( Int( ::nWidth ) ) )
   cHeight = LTrim( Str( Int( ::nHeight ) ) )
 
   cCode += CRLF + "   @ " + cTop + ", " + cLeft + ;
            " BROWSE " + ::cVarName + " ;" + CRLF + ;
            '      FIELDS "", "", ""' + " ;" + CRLF + ;
            "      SIZE " + cWidth + ", " + cHeight + ;
            " PIXEL OF " + ::oWnd:cVarName + CRLF

return cCode

//----------------------------------------------------------------------------//

METHOD DrawHeaders( nPEvent ) CLASS TWBrowse

   local aHeaders := {}, aColSizes := {}
   local n

   for n = 1 to Len( ::aColumns )
      AAdd( aHeaders, ::aColumns[ n ]:cHeading )
      AAdd( aColSizes, ::aColumns[ n ]:nWidth )
   next

   BrwDrawHeaders( ::hWnd, nPEvent, aHeaders, aColSizes, ::nColPos )

return nil

//----------------------------------------------------------------------------//

METHOD DrawLine( nRow, lSelected ) CLASS TWBrowse

   local n := ::nColPos, nColPos := 1, nWidth := ::nWidth,;
              nCols := Len( ::aColumns )
   local hWnd := ::hWnd, nRowAct := ::nRowPos

   DEFAULT nRow := ::nRowPos, lSelected := .f.

   while nColPos < nWidth .and. n <= nCols
      BrwDrawCell( hWnd, ( 20 * nRow ) + 1, nColPos,;
                   RTrim( cValToChar( Eval( ::aColumns[ n ]:bBlock ) ) ),;
		   If( n == Len( ::aColumns ) .or. ;
		   nColPos + ::aColumns[ n ]:nWidth > ::nWidth,;
		   ::nWidth - nColPos - 1,;
		   ::aColumns[ n ]:nWidth - 2 ), lSelected,;
                   If( ValType( ::nClrPane ) == "B", Eval( ::nClrPane, nRow, lSelected ), ::nClrPane ),;
                   If( ValType( ::nClrText ) == "B", Eval( ::nClrText, nRow, lSelected ), ::nClrText ) )
      nColPos += ::aColumns[ n++ ]:nWidth - 1
   end

return nil

//----------------------------------------------------------------------------//

METHOD DrawLines() CLASS TWBrowse

   local aColSizes := {}

   for n = 1 to Len( ::aColumns )
      AAdd( aColSizes, ::aColumns[ n ]:nWidth )
   next

   BrwDrawLines( ::hWnd, aColSizes, ::nColPos )

return nil

//----------------------------------------------------------------------------//

METHOD DrawRows() CLASS TWBrowse

   local n := 1, nLines := ::nRowCount(), nSkipped := 1

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) > 0

      ::Skip( 1 - ::nRowPos )

      while n <= nLines .and. nSkipped == 1
         ::DrawLine( n )
         nSkipped = ::Skip( 1 )
         if nSkipped == 1
            n++
         endif
      end
      ::Skip( ::nRowPos - n )

      if ::nLen < ::nRowPos
         ::nRowPos = ::nLen
      endif

      ::DrawSelect()
   endif

   if ! Empty( ::cAlias ) .and. Upper( ::cAlias ) != "ARRAY"
      ::lHitTop    = ( ::cAlias )->( BoF() )
      ::lHitBottom = ( ::cAlias )->( EoF() )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoBottom() CLASS TWBrowse

   local nSkipped
   local nLines := ::nRowCount() - 1
   local n

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitBottom
      ::lHitBottom = .t.
      ::lHitTop    = .f.

      Eval( ::bGoBottom, Self )

      nSkipped = ::Skip( -( nLines - 1 ) )
      ::nRowPos = 1 - nSkipped

      for n = 1 to -nSkipped + 1 // warning: this +1 is new for FiveLinux
          ::DrawLine( n )
          ::Skip( 1 )
      next
      ::DrawSelect()

      ::oVScroll:SetValue( ::nLen )

      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoDown() CLASS TWBrowse

   local nLines := ::nRowCount() - 1

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitBottom
      ::DrawLine()
      if ::Skip( 1 ) == 1
         ::lHitTop = .f.
         if ::nRowPos < nLines
            ::nRowPos++
         else
            BrwScrollUp( ::hWnd )
	    ::DrawLines()
         endif
      else
         ::lHitBottom = .t.
      endif
      ::DrawSelect()
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoLeft() CLASS TWBrowse

   if ::nColPos > 1
      ::nColPos--
      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoRight() CLASS TWBrowse

   if ::nColPos < Len( ::aColumns )
      ::nColPos++
      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoTop() CLASS TWBrowse

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitTop
      Eval( ::bGoTop, Self )
      ::lHitTop = .t.
      ::lHitBottom = .f.
      ::nRowPos = 1
      ::DrawRows()
      ::DrawSelect()
      if ::oVScroll != nil
         ::oVScroll:GoTop()
      endif 
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoUp() CLASS TWBrowse

   local nLines := ::nRowCount()

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitTop
      ::DrawLine()
      if ::Skip( -1 ) == -1
         ::lHitBottom = .f.
         if ::nRowPos > 1
            ::nRowPos--
         else
            BrwScrollDown( ::hWnd )
	    ::DrawLines()
         endif
      else
         ::lHitTop = .t.
      endif
      ::DrawSelect()
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoTo( nPos ) CLASS TWBrowse

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if nPos <= 1
      ::GoTop()
   elseif nPos == ::oVScroll:GetRange()[ 2 ]
      ::GoBottom()
   else
      ::Skip( nPos - ::oVScroll:nValue )
      ::lHitTop = .f.
      ::lHitBottom = .f.
      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TWBrowse

   do case
      case nMsg == WM_KEYDOWN
           ::KeyDown( nWParam )

      case nMsg == WM_LDBLCLICK
           ::LDblClick( nWParam, nLParam )

      case nMsg == WM_PAINT
           ::Paint( nWParam )

      case nMsg == WM_RBUTTONDOWN
           ::RButtonDown( nWParam, nLParam )

   endcase

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey ) CLASS TWBrowse

   do case
      case nKey == K_DOWN
           ::GoDown()
	   ::oVScroll:SetValue( ::oVScroll:GetValue() + 1 )

      case nKey == K_UP
           ::GoUp()
	   ::oVScroll:SetValue( ::oVScroll:GetValue() - 1 )

      case nKey == K_HOME
           ::GoTop()
	   ::oVScroll:SetValue( 1 )

      case nKey == K_END
           ::GoBottom()

      case nKey == K_PAGEUP
           ::PageUp()

      case nKey == K_PAGEDOWN
           ::PageDown()

      case nKey == K_LEFT
           ::GoLeft()
	   ::oHScroll:SetValue( ::oHScroll:GetValue() - 1 )

      case nKey == K_RIGHT
           ::GoRight()
	   ::oHScroll:SetValue( ::oHScroll:GetValue() + 1 )
   endcase

   if ! Empty( ::bKeyDown )
      Eval( ::bKeyDown, nKey, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol ) CLASS TWBrowse

   local nRowSize := ::nHeight / ::nRowCount()
   local nRowAt   := Int( nRow / nRowSize )
   local nRowPos  := ::nRowPos
   local nSkipped

   if ::lDrag
      return Super:LButtonDown( nRow, nCol )
   endif

   ::SetFocus()

   if nRowAt == 0 // .or. nRowAt == nRowPos // so we can use bLClicked on the selected row
      return nil
   endif

   ::DrawLine( nRowPos )
   if ( nSkipped := ::Skip( nRowAt - nRowPos ) ) != 0
      ::nRowPos = nRowAt
      ::oVScroll:SetValue( ::oVScroll:GetValue() + ( nRowAt - nRowPos ) )
      if ! Empty( ::bChange )
         Eval( ::bChange, Self )
      endif
   endif

   if ! Empty( ::bLClicked )
      Eval( ::bLClicked, nRowAt, nCol, Self )
   endif

   ::DrawSelect()

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol ) CLASS TWBrowse

   if ::lDrag
      if IsLBtnPressed( ::hWnd ) .and. ::nStartRow != nil
         Super:MouseMove( nRow, nCol )

         ::oVScroll:SetPos( ::nTop, ::nLeft + ::nWidth + 2 )
         ::oHScroll:SetPos( ::nTop + ::nHeight + 2, ::nLeft )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD PageDown( nLines ) CLASS TWBrowse

   local nSkipped, n

   DEFAULT nLines := ::nRowCount() - 1

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitBottom
      ::DrawLine()
      nSkipped = ::Skip( ( nLines * 2 ) - ::nRowPos )

      if nSkipped != 0
         ::lHitTop = .f.
      endif

      do case
         case nSkipped == 0 .or. nSkipped < nLines
              if nLines - ::nRowPos < nSkipped
                 ::Skip( -( nLines ) )
                 for n = 1 to ( nLines - 1 )
                     ::Skip( 1 )
                     ::DrawLine( n )
                 next
                 ::Skip( 1 )
              endif
              ::nRowPos = Min( ::nRowPos + nSkipped, nLines )
              ::lHitBottom = .t.
              if ::oVScroll != nil
                 ::oVScroll:SetValue( ::oVScroll:GetRange()[ 2 ] )
              endif

         otherwise
              for n = nLines to 1 step -1
                  ::DrawLine( n )
                  ::Skip( -1 )
              next
              ::Skip( ::nRowPos )
      endcase

      ::DrawSelect()
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif

      if ! ::lHitBottom
         ::oVScroll:SetValue( ::oVScroll:GetValue() + nSkipped - ;
	                      ( nLines - ::nRowPos ) )
      else
         ::oVScroll:SetValue( ::oVScroll:GetRange()[ 2 ] )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD PageUp( nLines ) CLASS TWBrowse

   local nSkipped

   DEFAULT nLines := ::nRowCount() - 1

   nSkipped = ::Skip( -nLines )

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitTop
      if nSkipped == 0
         ::lHitTop = .t.
      else
         ::lHitBottom = .f.
         if -nSkipped < nLines
            ::nRowPos = 1
            ::oVScroll:SetValue( 1 )
         else
            nSkipped = ::Skip( -nLines )
            ::Skip( -nSkipped )
            ::oVScroll:SetValue( ::oVScroll:GetValue() + nSkipped )
         endif
	 ::DrawRows()
	 ::DrawSelect()
         if ::bChange != nil
            Eval( ::bChange, Self )
         endif

      endif
   else
      ::oVScroll:SetValue( 1 )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Paint( nPEvent ) CLASS TWBrowse

   // if ! ::lSetVRange
   //    ::oVScroll:SetRange( 1, Eval( ::bLogicLen, Self ), ::nRowCount() )
   //    ::lSetVRange = .t.
   // endif

   ::DrawHeaders( nPEvent )
   ::DrawLines( nPEvent )
   ::DrawRows()
   ::DrawSelect()

return nil

//----------------------------------------------------------------------------//

METHOD SetSize( nWidth, nHeight ) CLASS TWBrowse

   Super:SetSize( nWidth, nHeight )

   if ::oVScroll != nil
      ::oVScroll:SetPos( ::oVScroll:nTop, ::nLeft + nWidth + 1 )
      ::oVScroll:SetSize( ::oVScroll:nWidth, nHeight )
   endif

   if ::oHScroll != nil
      ::oHScroll:SetPos( ::nTop + nHeight + 1, ::oHScroll:nLeft )
      ::oHScroll:SetSize( nWidth, ::oHScroll:nHeight )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Skip( n ) CLASS TWBrowse

   if ::bSkip != nil
      return Eval( ::bSkip, n, Self )
   endif

return If( ! Empty( ::cAlias ), ( ::cAlias )->( __DBSkipper( n ) ), 0 )

//----------------------------------------------------------------------------//

METHOD SetAltColors( nClrText, nClrPane, nClrTextS, nClrPaneS ) CLASS TWBrowse

   if ::cAlias != "ARRAY"
      ::nClrPane = { | nRow, lSelected | If( ! lSelected,;
         If( ( ::cAlias )->( OrdKeyNo() ) % 2 == 0, nClrPane, nClrPaneS ), nil ) } 
      ::nClrText = { | nRow, lSelected | If( ! lSelected,;
         If( ( ::cAlias )->( OrdKeyNo() ) % 2 == 0, nClrText, nClrTextS ), nil ) } 
   else
      ::nClrPane = { | nRow, lSelected | If( ! lSelected,;
                     If( ::nAt % 2 == 0, nClrPane, nClrPaneS ), nil ) } 
      ::nClrText = { | nRow, lSelected | If( ! lSelected,;
                     If( ::nAt % 2 == 0, nClrText, nClrTextS ), nil ) } 
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetArray( aArray ) CLASS TWBrowse

   ::nAt       = 1
   ::cAlias    = "ARRAY"
   ::bLogicLen = { || ::nLen := Len( aArray ) }
   ::bGoTop    = { || ::nAt := 1 }
   ::bGoBottom = { || ::nAt := Eval( ::bLogicLen, Self ) }
   ::bSkip     = { | nSkip, nOld | nOld := ::nAt, ::nAt += nSkip,;
                  ::nAt := Min( Max( ::nAt, 1 ), Eval( ::bLogicLen, Self ) ),;
                  ::nAt - nOld }
   ::oVScroll:SetRange( 1, Len( aArray ), ::nRowCount / Len( aArray ) )
            
return nil 

//----------------------------------------------------------------------------//

function GetFieldNames()

   local aStruct := DbStruct(), n, aFields := {}

   for n = 1 to Len( aStruct )
      AAdd( aFields, aStruct[ n ][ 1 ] )
   next

return aFields

//----------------------------------------------------------------------------//
