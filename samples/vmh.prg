#include "FiveLinux.ch"

#define CLR_GRAY1 0xCCCCCC
#define CLR_GRAY2 0xEEEEEE
#define CLR_TEXT  0x303030

static aPrgs := { { "", "", "" } }

//----------------------------------------------------------------------------//

function Main()

   local oDlg, oGet1, cPrgName := Space( 20 ), oFld1
   local oBrwPrgs
   local oResult, cResult := "", nRetCode

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
      FIELDS aPrgs[ oBrwPrgs:nArrayAt ][ 1 ],;
             aPrgs[ oBrwPrgs:nArrayAt ][ 2 ],;
             aPrgs[ oBrwPrgs:nArrayAt ][ 3 ] ;
      HEADERS "Name", "Date", "Size" ;
      COLSIZES 180, 85, 85 ;
      OF oFld1:aDialogs[ 1 ] SIZE 335, 160 PIXEL

   oBrwPrgs:SetArray( aPrgs )
   oBrwPrgs:SetAltColors( CLR_TEXT, CLR_GRAY1, CLR_TEXT, CLR_GRAY2 )

   @  108, 322 BUTTON "+" OF oDlg SIZE 25, 25 PIXEL ;
      ACTION MsgInfo( "add" )

   @  108, 350 BUTTON "-" OF oDlg SIZE 25, 25 PIXEL ;
      ACTION MsgInfo( "delete" )

   @ 328,  13 SAY "Result" SIZE  80,  20 PIXEL OF oDlg

   @ 347,  20 GET oResult VAR cResult MEMO SIZE 363, 144 OF oDlg PIXEL

   @ 31, 412 BUTTON "_Build" ;
      SIZE 123, 50 PIXEL OF oDlg ;
      ACTION ( __Run( "~/harbour/bin/hbmk2 " + ;
                      "-i~/fivelinux/include " + ; 
                      AllTrim( cPrgName ) + ;
                      " > out.log" ),;
               oResult:SetText( AllTrim( Str( ErrorLevel() ) ) + CRLF + ;
                                MemoRead( "out.log" ) ) ) 

   @ 87, 412 BUTTON "_Settings" ;
      SIZE 124, 50 PIXEL OF oDlg ;
      ACTION Settings()

   @ 143, 412 BUTTON "_Exit" ;
      SIZE 124, 50 PIXEL OF oDlg ;
      ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return oDlg

//----------------------------------------------------------------------------//

function Settings()

   local oDlg

   DEFINE DIALOG oDlg TITLE "Settings" SIZE 400, 400

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//
