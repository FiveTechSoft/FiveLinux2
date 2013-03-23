#include "FiveLinux.ch"

#define CLR_GRAY1 0xCCCCCC
#define CLR_GRAY2 0xEEEEEE
#define CLR_TEXT  0x303030

static aPrgs := { { "", "", "" } }
static lFLH := .T.
static cHbmkPath, cFLHPath
static aDefines := { { "", "" } }

//----------------------------------------------------------------------------//

function Main()

   local oDlg, oGet1, cPrgName := Space( 20 ), oFld1
   local oBrwPrgs
   local oResult, cResult := "", cCmd, nRetCode

   cHbmkPath := GetEnv( "HOME" ) + "/harbour/bin/hbmk2"
   cFLHPath  := GetEnv( "HOME" ) + "/fivelinux"

   DEFINE DIALOG oDlg TITLE "Visual Make for Harbour" ;
      SIZE 557, 500

   @  20,  20 SAY "Main PRG" SIZE  80,  20 PIXEL OF oDlg

   @  41,  20 GET oGet1 VAR cPrgName SIZE 326, 26 PIXEL OF oDlg ;
      VALID ! Empty( cPrgName )

   @  41, 350 BUTTON "..." OF oDlg SIZE 25, 25 PIXEL ;
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

   @ 347,  20 GET oResult VAR cResult MEMO SIZE 515, 144 OF oDlg PIXEL

   @ 31, 412 BUTTON "_Build" ;
      SIZE 123, 50 PIXEL OF oDlg ;
      ACTION ( cCmd := cHbmkPath + " " + ;
               If( lFLH, "-i" + cFLHPath + "/include ", "" ) + ; 
               AllTrim( cPrgName ) + " " + ;
               If( lFLH, "-l" + "five ", "" ) + ;
               If( lFLH, "-l" + "fivec ", "" ) + ;
               If( lFLH, "`pkg-config --libs gtk+-2.0` ", "" ) + ;
               If( lFLH, "`pkg-config --libs libglade-2.0` ", "" ) + ;
               If( lFLH, "-L" + cFLHPath + "/lib ", "" ) + ;
               "xhb.hbc " + ;
               " > out.log",;
               nRetCode := hb_Run( cCmd ),;
               oResult:SetText( AllTrim( Str( nRetCode ) ) + CRLF + ;
                                cCmd + CRLF + ; 
                                MemoRead( "out.log" ) ),;
               hb_run( cFileNoExt( cPrgName ) ) ) 

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

   local oDlg, lFLHTemp := lFLH, cHbmkPathTemp := cHbmkPath
   local oGetFLH, cFLHPathTemp := cFLHPath
   local oBrwDefines

   DEFINE DIALOG oDlg TITLE "Settings" SIZE 550, 400

   @ 20, 20 SAY "hbmk2 path" OF oDlg SIZE 80, 12 PIXEL

   @ 40, 20 GET oGetPath VAR cHbmkPathTemp SIZE 326, 26 PIXEL OF oDlg ;
      VALID ! Empty( cHbmkPathTemp )

   @ 40, 350 BUTTON "..." OF oDlg SIZE 25, 25 PIXEL ;
      ACTION ( oGetPath:VarPut( cHbmkPathTemp := ;
               cGetFile( "Please select the hbmk2 path", "hbmk2" ) ),;
               oGetPath:Refresh() )

   @ 110, 20 GET oGetFLH VAR cFLHPathTemp SIZE 326, 26 PIXEL OF oDlg ;
      VALID ! Empty( cFLHPathTemp )

   @ 110, 350 BUTTON "..." OF oDlg SIZE 25, 25 PIXEL ;
      ACTION ( oGetFLH:VarPut( cFLHPathTemp := ;
               cGetFile( "Please select the FiveLinux path" ) ),;
               oGetFLH:Refresh() )

   @ 90, 20 CHECKBOX lFLHTemp PROMPT "Use FiveLinux libraries" ;
      OF oDlg SIZE 180, 15 PIXEL ;
      ON CHANGE If( lFLHTemp, oGetFLH:Enable(), oGetFLH:Disable() )

   @ 165, 5 SAY "Defines" OF oDlg SIZE 80, 14 PIXEL

   @ 156, 322 BUTTON "+" OF oDlg SIZE 25, 25 PIXEL ;
      ACTION MsgInfo( "add" )

   @ 156, 350 BUTTON "-" OF oDlg SIZE 25, 25 PIXEL ;
      ACTION MsgInfo( "delete" )

   @ 185, 20 BROWSE oBrwDefines ;
      FIELDS aDefines[ oBrwDefines:nArrayAt ][ 1 ],;
             aDefines[ oBrwDefines:nArrayAt ][ 2 ] ;
      HEADERS "Name", "Value" ;
      COLSIZES 180, 180 ;
      OF oDlg SIZE 335, 160 PIXEL

   oBrwDefines:SetArray( aDefines )
   oBrwDefines:SetAltColors( CLR_TEXT, CLR_GRAY1, CLR_TEXT, CLR_GRAY2 )

   @ 31, 412 BUTTON "_Save" ;
      SIZE 123, 50 PIXEL OF oDlg ;
      ACTION ( cHbmkPath := cHbmkPathTemp,;
               lFLH := lFLHTemp,;
               cFLHPath  := cFLHPathTemp,;
               oDlg:End() )

   @ 87, 412 BUTTON "_Cancel" ;
      SIZE 124, 50 PIXEL OF oDlg ;
      ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//
