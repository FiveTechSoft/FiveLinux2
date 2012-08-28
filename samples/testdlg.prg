#include "FiveLinux.ch"

REQUEST HB_LANG_ESWIN 

function Main()

   local oDlg, cName := Date() /* PadR( "Five", 24 ) */
   local cAddress := Space( 20 ), nVal := 0

   HB_LANGSELECT( 'ESWIN' )

   DEFINE DIALOG oDlg TITLE "FiveLinux DialogBox"

   @ 2, 2 SAY "Name:" OF oDlg

   @ 2, 8 GET cName OF oDlg SIZE 120, 25

   @ 2, 32 IMAGE FILENAME "flh.gif" OF oDlg

   @ 6, 2 SAY "Address:" OF oDlg

   @ 6, 8 GET cAddress OF oDlg SIZE 150, 25 ;
      VALID If( Empty( cAddress ),;
                ( MsgInfo( "please write something" ), .f. ), .t. )

   @ 10, 2 SAY "Value:" OF oDlg

   @ 10, 8 GET nVal PICTURE "999.99" OF oDlg SIZE 120, 25

   @ 15, 2 BUTTON "_Another" OF oDlg ACTION Another()

   @ 15, 12 BUTTON "_Disabled" OF oDlg WHEN .f.

   @ 15, 22 BUTTON "Show text" OF oDlg ACTION MsgInfo( cAddress )

   ACTIVATE DIALOG oDlg CENTERED ;
      VALID MsgYesNo( "Want to end ?" )

return nil

function Another()

   local oDlg

   DEFINE DIALOG oDlg TITLE hb_strtoutf8( "Limón Another dialog" )

   ACTIVATE DIALOG oDlg CENTERED ;
      VALID MsgYesNo( "End ?" )

return nil

