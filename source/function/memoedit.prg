#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

function MemoEdit( cText, cTitle ) // cText by reference

   local oDlg, cTemp := cText, lChanged := .F.

   DEFAULT cTitle := "MemoEdit"

   DEFINE DIALOG oDlg TITLE cTitle SIZE 600, 300

   @ 0, 0 GET cTemp MEMO OF oDlg SIZE 600, 250

   @ 26.5, 18 BUTTON "Ok" OF oDlg ;
      ACTION ( cText := cTemp, lChanged := .T., oDlg:End() )

   @ 26.5, 32 BUTTON "Cancel" OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return lChanged

//----------------------------------------------------------------------------//
