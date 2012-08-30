#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TDialog FROM TWindow

   DATA   lModal   // The execution waits until the dialog is closed

   METHOD New( cTitle, nWidth, nHeight, cResName )

   METHOD Activate( lCentered, bValid, bLClicked, bRClicked, lModal )

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD SetSize( nWidth, nHeight ) INLINE CtrlSetSize( ::hWnd, nWidth, nHeight )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cTitle, nWidth, nHeight, cResName ) CLASS TDialog

   DEFAULT cTitle := "FiveLinux", nWidth := 522, nHeight := 314

   if Empty( cResName )
      ::hWnd = CreateDialog()
   else
      ::hWnd = LoadDialog( cResName )
   endif

   if Empty( ::hWnd )
      MsgAlert( "can't create dialog box " + cResName )
   endif

   ::aControls = {}

   ::SetText( cTitle )

   ::Link()

   ::SetSize( nWidth, nHeight )

   SetWndDefault( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Activate( lCentered, bValid, bLClicked, bRClicked, lModal ) CLASS TDialog

   local n

   DEFAULT lCentered := .f., lModal := .t.

   ::bValid    = bValid
   ::bLClicked = bLClicked
   ::bRClicked = bRClicked
   ::lModal    = lModal

   if lCentered
      ::Center()
   endif

   if lModal
      SetModal( ::hWnd )
   endif

   ::AEvalWhen()
   ::Show()

   if ! Empty( ::bStart )
      Eval( ::bStart, Self )
   endif   

   // Listbox controls initialization workaround
   for n = 1 to Len( ::aControls )
      if ::aControls[ n ]:ClassName() == "TLISTBOX"
         ::aControls[ n ]:SelItem( ::aControls[ n ]:nAt )
      endif
   next

   WinRun()

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TDialog

   do case
        case nMsg == WM_CLOSE
	        return ::End()

	case nMsg == WM_MENUCMD
	        if ::oPopup != nil
		   ::oPopup:Command( nWParam )
		   ::oPopup = nil
		   return nil
		else
	           return ::oMenu:Command( nWParam )
		endif

	case nMsg == WM_LBUTTONDOWN
	        return ::LButtonDown()

	case nMsg == WM_RBUTTONDOWN
	        return ::RButtonDown()
   endcase

return nil

//----------------------------------------------------------------------------//
