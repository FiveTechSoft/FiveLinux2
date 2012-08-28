#include "FiveLinux.ch"

function Main()

   local oDlg, cName := PadR( "Five", 24 ), cAddress := Space( 40 ), nRad := 2
   local oRad, cText := "This is a text", oGrp

   DEFINE DIALOG oDlg TITLE "FiveLinux DialogBox"

   @ 2, 2 SAY "Name:" OF oDlg

   @ 2, 8 GET cName OF oDlg SIZE 120, 25

   @ 2, 32 IMAGE FILENAME "flh.gif" OF oDlg

   @ 6, 2 SAY "Address:" OF oDlg

   @ 6, 8 GET cAddress OF oDlg SIZE 150, 25 ;
      VALID If( Empty( cAddress ),;
                ( MsgInfo( "please write something" ), .f. ), .t. )

   @  9, 1 GROUP oGrp LABEL "Group" OF oDlg

   @ 11, 3 RADIO oRad VAR nRad ITEMS { "_One", "_Two", "T_hree" } OF oDlg

   @  9.5, 23 GET cText MEMO OF oDlg

   @ 23,  2 BUTTON "_Another" OF oDlg ACTION MsgInfo( cText )

   @ 23, 12 BUTTON "_Disabled" OF oDlg WHEN .f.

   ACTIVATE DIALOG oDlg CENTERED ;
      VALID MsgYesNo( "Want to end ?" )

return nil

function Another()

   local oDlg

   DEFINE DIALOG oDlg TITLE "Another dialog"

   ACTIVATE DIALOG oDlg CENTERED ;
      VALID MsgYesNo( "End ?" )

return nil
