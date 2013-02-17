#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TControl FROM TWindow

   DATA   bSetGet   // A bSetGet codeblock to manage a related variable value
   DATA   bWhen     // A codeblock to evaluate to activate or not the control
   DATA   lUpdate   // Update the control contents if its container is updated
   DATA   bChange   // A codeblock to evaluate when the control changes its main value
   DATA   lDrag  INIT .F.  // moveable with the mouse
   DATA   nStartRow, nStartCol // initial coors when design drag starts

   METHOD GenLocals() INLINE ", " + ::cVarName

   METHOD GetCtrlIndex()

   METHOD LostFocus()

   METHOD End() INLINE WndDestroy( ::hWnd )

   METHOD LButtonDown( nRow, nCol )

   METHOD nLeft() INLINE GetLeft( ::hWnd )

   METHOD _nLeft( nLeft ) INLINE CtrlSetPos( ::hWnd, ::nTop, nLeft ) 

   METHOD nTop() INLINE GetTop( ::hWnd )

   METHOD _nTop( nTop ) INLINE CtrlSetPos( ::hWnd, nTop, ::nLeft ) 

   METHOD Show() INLINE ShowControl( ::hWnd )

   METHOD SetFont( oFont ) INLINE If( ::oFont != nil, ::oFont:End(),),;
                           ::oFont := oFont, SetFont( ::hWnd, oFont:hFont )

   METHOD SetPos( nTop, nLeft ) INLINE CtrlSetPos( ::hWnd, nTop, nLeft )

   METHOD SetSize( nWidth, nHeight ) INLINE CtrlSetSize( ::hWnd, nWidth, nHeight )

   METHOD MouseMove( nRow, nCol )

ENDCLASS

//----------------------------------------------------------------------------//
 
METHOD GetCtrlIndex() CLASS TControl
 
   local n, nIndex := 0
 
   for n = 1 to Len( ::oWnd:aControls )
      if ::oWnd:aControls[ n ]:ClassName() == ::ClassName()
         nIndex++
      endif
   next
 
return AllTrim( Str( nIndex ) )         
 
//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol ) CLASS TControl

   if ::lDrag
      ::nStartRow = nRow
      ::nStartCol = nCol
      if ::oWnd:oInspector != nil
         ::oWnd:oInspector:SetControl( Self )
      endif
   endif

   ::Super:LButtonDown( nRow, nCol )

return If( ::lDrag, 1, nil )  // no default behavior for lDrag 

//----------------------------------------------------------------------------//

METHOD LostFocus() CLASS TControl

   if ::bValid != nil
      if ! Eval( ::bValid, Self )
         ::SetFocus()
      endif
   endif

   ::oWnd:AEvalWhen()

   if ::bLostFocus != nil
      Eval( ::bLostFocus, Self )
   endif   

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol ) CLASS TControl

   if ::lDrag
      if IsLBtnPressed( ::hWnd ) .and. ::nStartRow != nil
         if ::ClassName() $ "TLISTBOX,TCOMBOBOX"
            ::SetPos( MouseGetRow( ::oWnd:hWnd ) - ::nStartRow, nCol - ::nStartCol )
         else
            ::SetPos( nRow - ::nStartRow, nCol - ::nStartCol )
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//
