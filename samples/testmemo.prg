#include "FiveLinux.ch"

function Main()

   local oDlg, cMemo := ""

   DEFINE DIALOG oDlg TITLE "Memo example"

   @ 2, 2 GET cMemo MEMO OF oDlg SIZE 480, 200

   @ 25, 12 BUTTON "Ok" OF oDlg ACTION MsgInfo( cMemo )

   @ 25, 28 BUTTON "Cancel" OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return nil
