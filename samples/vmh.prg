#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

function Main()

   local oDlg, oGet1, cPrgName := Space( 20 ), oFld1
   local oBrwPrgs
   local oResult, cResult := ""

   DEFINE DIALOG oDlg TITLE "Visual Make for Harbour" ;
      SIZE 557, 500

   @  20,  20 SAY "Main PRG" SIZE  80,  20 PIXEL OF oDlg

   @  41,  20 GET oGet1 VAR cPrgName SIZE 300,  26 PIXEL OF oDlg

   @  41, 322 BUTTON "..." OF oDlg SIZE 25, 25 PIXEL ;
      ACTION ( oGet1:VarPut( cPrgName := cGetFile( "Please select a PRG file", "*.prg" ) ),;
               oGet1:Refresh() )

   @  86,  20 SAY "Additional" SIZE  80,  20 PIXEL OF oDlg

   @ 108, 20 FOLDER oFld1 PROMPTS "PRGs", "Cs", "OBJs", "LIBs", "HBCs" ;
      SIZE 363, 210 PIXEL OF oDlg

   @ 138, 25 BROWSE oBrwPrgs ;
      FIELDS "", "", "" ;
      HEADERS "Name", "Date", "Size" ;
      COLSIZES 180, 85, 85 ;
      OF oFld1:aDialogs[ 1 ] SIZE 335, 160 PIXEL DESIGN

   @  108, 322 BUTTON "+" OF oDlg SIZE 25, 25 PIXEL ;
      ACTION MsgInfo( "add" )

   @  108, 350 BUTTON "-" OF oDlg SIZE 25, 25 PIXEL ;
      ACTION MsgInfo( "delete" )

   @ 328,  13 SAY "Result" SIZE  80,  20 PIXEL OF oDlg

   @ 347,  20 GET oResult VAR cResult MEMO SIZE 363, 144 OF oDlg PIXEL

   @ 31, 412 BUTTON "_Build" ;
      SIZE 123, 50 PIXEL OF oDlg ;
      ACTION MsgInfo( "Not defined yet!" )

   @ 87, 412 BUTTON "_Settings" ;
      SIZE 124, 50 PIXEL OF oDlg ;
      ACTION MsgInfo( "Not defined yet!" )

   @ 143, 412 BUTTON "_Exit" ;
      SIZE 124, 50 PIXEL OF oDlg ;
      ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return oDlg

//----------------------------------------------------------------------------//
