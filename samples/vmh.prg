#include "FiveLinux.ch"

#define CLR_GRAY1 0xCCCCCC
#define CLR_GRAY2 0xEEEEEE
#define CLR_TEXT  0x303030

static lFLH := .T.
static cPrgName, cHbmkPath, cFLHPath
static aDefines := { { "", "" } }
static oBrwPrgs, aPrgs := { { "", "", "" } }
static oBrwCs, aCs := { { "", "", "" } }
static oBrwObjs, aObjs := { { "", "", "" } }
static oBrwLibs, aLibs := { { "", "", "" } }
static oBrwRcs, aRcs := { { "", "", "" } }
static oBrwHbcs, aHbcs := { { "", "", "" } }

//----------------------------------------------------------------------------//

function Main()

   local oDlg, oGet1, oFld
   local oBrwPrgs, cFileName
   local oResult, cResult := "", cCmd, nRetCode

   cPrgName  = Space( 20 )
   cHbmkPath = GetEnv( "HOME" ) + "/harbour/bin/hbmk2"
   cFLHPath  = GetEnv( "HOME" ) + "/fivelinux"

   // LoadPreferences()
   LoadProject()

   DEFINE DIALOG oDlg TITLE "Visual Make for Harbour" ;
      SIZE 557, 500

   @  20,  20 SAY "Main PRG" SIZE  80,  20 PIXEL OF oDlg

   @  41,  20 GET oGet1 VAR cPrgName SIZE 326, 26 PIXEL OF oDlg ;
      VALID ! Empty( cPrgName )

   @  41, 350 BUTTON "..." OF oDlg SIZE 25, 25 PIXEL ;
      ACTION ( oGet1:VarPut( cPrgName := cGetFile( "*.prg", "Please select a PRG file" ) ),;
               oGet1:Refresh() )

   @  86,  20 SAY "Additional" SIZE  80,  20 PIXEL OF oDlg

   @ 108, 20 FOLDER oFld PROMPTS "PRGs", "Cs", "OBJs", "LIBs", "RCs", "HBCs" ;
      SIZE 363, 210 PIXEL OF oDlg

   BuildBrowses( oFld )

   @  108, 322 BUTTON "+" OF oDlg SIZE 25, 25 PIXEL ;
      ACTION ( cFileName := cGetFile( { "*.prg", "*.c", "*.obj", "*.lib", "*.rc", "*.hbc" }[ oFld:nOption ],;
                                      "Please select a " + ;
                                      { "PRG", "C", "OBJ", "LIB", "RC", "HBC" }[ oFld:nOption ] + " file" ),;
               If( ! Empty( cFileName ),;
                   ( If( { aPrgs, aCs, aObjs, aLibs, aRcs, aHbcs }[ oFld:nOption ][ 1 ][ 1 ] == "",;
                     ASize( { aPrgs, aCs, aObjs, aLibs, aRcs, aHbcs }[ oFld:nOption ], 0 ),),;
                     AAdd( { aPrgs, aCs, aObjs, aLibs, aRcs, aHbcs }[ oFld:nOption ],;
                           { cFileName, Directory( cFileName )[ 1 ][ 2 ],;
                                    Directory( cFileName )[ 1 ][ 3 ] } ),;
                     oFld:aDialogs[ oFld:nOption ]:aControls[ 1 ]:GoBottom(),;
                     oFld:aDialogs[ oFld:nOption ]:aControls[ 1 ]:SetFocus() ), ) )

   @  108, 350 BUTTON "-" OF oDlg SIZE 25, 25 PIXEL ;
      ACTION ( ADel( { aPrgs, aCs, aObjs, aLibs, aRcs, aHbcs }[ oFld:nOption ],;
               oFld:aDialogs[ oFld:nOption ]:aControls[ 1 ]:nArrayAt ),;
               ASize( { aPrgs, aCs, aObjs, aLibs, aRcs, aHbcs }[ oFld:nOption ],;
                      Len( { aPrgs, aCs, aObjs, aLibs, aRcs, aHbcs }[ oFld:nOption ] ) - 1 ),;
               If( Len( { aPrgs, aCs, aObjs, aLibs, aRcs, aHbcs }[ oFld:nOption ] ) == 0,;
                   AAdd( { aPrgs, aCs, aObjs, aLibs, aRcs, aHbcs }[ oFld:nOption ], { "", "", "" } ),),;
               oFld:Refresh() )

   @ 328,  13 SAY "Result" SIZE  80,  20 PIXEL OF oDlg

   @ 347,  20 GET oResult VAR cResult MEMO SIZE 515, 144 OF oDlg PIXEL

   @ 31, 412 BUTTON "_Build" ;
      SIZE 123, 50 PIXEL OF oDlg ;
      ACTION ( cCmd := cHbmkPath + " " + ;
               If( lFLH, "-i" + cFLHPath + "/include ", "" ) + ; 
               AllTrim( cPrgName ) + " " + ;
               AToStr( aPrgs ) + " " + ;
               AToStr( aCs ) + " " + ;
               AToStr( aObjs ) + " " + ;
               AToStr( aLibs ) + " " + ;
               AToStr( aRcs ) + " " + ;
               AToStr( aHbcs ) + " " + ;
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

   SaveProject()
   // SavePreferences()

return oDlg

//----------------------------------------------------------------------------//

function BuildBrowses( oFld )

   @ 138, 25 BROWSE oBrwPrgs ;
      FIELDS SubStr( aPrgs[ oBrwPrgs:nArrayAt ][ 1 ], Len( GetEnv( "HOME" ) ) + 2 ),;
             aPrgs[ oBrwPrgs:nArrayAt ][ 2 ],;
             aPrgs[ oBrwPrgs:nArrayAt ][ 3 ] ;
      HEADERS "Name", "Size", "Date" ;
      COLSIZES 230, 45, 75 ;
      OF oFld:aDialogs[ 1 ] SIZE 335, 160 PIXEL

   oBrwPrgs:SetArray( aPrgs )
   oBrwPrgs:SetAltColors( CLR_TEXT, CLR_GRAY1, CLR_TEXT, CLR_GRAY2 )

   @ 138, 25 BROWSE oBrwCs ;
      FIELDS SubStr( aCs[ oBrwCs:nArrayAt ][ 1 ], Len( GetEnv( "HOME" ) ) + 2 ),;
             aCs[ oBrwCs:nArrayAt ][ 2 ],;
             aCs[ oBrwCs:nArrayAt ][ 3 ] ;
      HEADERS "Name", "Size", "Date" ;
      COLSIZES 230, 45, 75 ;
      OF oFld:aDialogs[ 2 ] SIZE 335, 160 PIXEL

   oBrwCs:SetArray( aCs )
   oBrwCs:SetAltColors( CLR_TEXT, CLR_GRAY1, CLR_TEXT, CLR_GRAY2 )

   @ 138, 25 BROWSE oBrwObjs ;
      FIELDS SubStr( aObjs[ oBrwObjs:nArrayAt ][ 1 ], Len( GetEnv( "HOME" ) ) + 2 ),;
             aCs[ oBrwObjs:nArrayAt ][ 2 ],;
             aCs[ oBrwObjs:nArrayAt ][ 3 ] ;
      HEADERS "Name", "Size", "Date" ;
      COLSIZES 230, 45, 75 ;
      OF oFld:aDialogs[ 3 ] SIZE 335, 160 PIXEL

   oBrwObjs:SetArray( aObjs )
   oBrwObjs:SetAltColors( CLR_TEXT, CLR_GRAY1, CLR_TEXT, CLR_GRAY2 )

   @ 138, 25 BROWSE oBrwLibs ;
      FIELDS SubStr( aLibs[ oBrwLibs:nArrayAt ][ 1 ], Len( GetEnv( "HOME" ) ) + 2 ),;
             aCs[ oBrwLibs:nArrayAt ][ 2 ],;
             aCs[ oBrwLibs:nArrayAt ][ 3 ] ;
      HEADERS "Name", "Size", "Date" ;
      COLSIZES 230, 45, 75 ;
      OF oFld:aDialogs[ 4 ] SIZE 335, 160 PIXEL

   oBrwLibs:SetArray( aLibs )
   oBrwLibs:SetAltColors( CLR_TEXT, CLR_GRAY1, CLR_TEXT, CLR_GRAY2 )

   @ 138, 25 BROWSE oBrwRcs ;
      FIELDS SubStr( aRcs[ oBrwRcs:nArrayAt ][ 1 ], Len( GetEnv( "HOME" ) ) + 2 ),;
             aCs[ oBrwRcs:nArrayAt ][ 2 ],;
             aCs[ oBrwRcs:nArrayAt ][ 3 ] ;
      HEADERS "Name", "Size", "Date" ;
      COLSIZES 230, 45, 75 ;
      OF oFld:aDialogs[ 5 ] SIZE 335, 160 PIXEL

   oBrwRcs:SetArray( aRcs )
   oBrwRcs:SetAltColors( CLR_TEXT, CLR_GRAY1, CLR_TEXT, CLR_GRAY2 )

   @ 138, 25 BROWSE oBrwHbcs ;
      FIELDS SubStr( aHbcs[ oBrwHbcs:nArrayAt ][ 1 ], Len( GetEnv( "HOME" ) ) + 2 ),;
             aCs[ oBrwHbcs:nArrayAt ][ 2 ],;
             aCs[ oBrwHbcs:nArrayAt ][ 3 ] ;
      HEADERS "Name", "Size", "Date" ;
      COLSIZES 230, 45, 75 ;
      OF oFld:aDialogs[ 6 ] SIZE 335, 160 PIXEL

   oBrwHbcs:SetArray( aHbcs )
   oBrwHbcs:SetAltColors( CLR_TEXT, CLR_GRAY1, CLR_TEXT, CLR_GRAY2 )

return nil

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
               SavePreferences(),;
               oDlg:End() )

   @ 87, 412 BUTTON "_Cancel" ;
      SIZE 124, 50 PIXEL OF oDlg ;
      ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//
 
function AToStr( aFiles )
 
   local cResult := ""
 
   AEval( aFiles, { | aFile | cResult += " " + aFile[ 1 ] } )
 
return cResult
 
//----------------------------------------------------------------------------//
 
function SavePreferences()
 
   local oIni, aDefine
 
   INI oIni FILE "vmh.ini"
      SET SECTION "Default" ENTRY "HbmkPath"  OF oIni TO cHbmkPath
      SET SECTION "Default" ENTRY "FLH"       OF oIni TO lFLH
      SET SECTION "Default" ENTRY "FLHPath"   OF oIni TO cFLHPath
 
      for each aDefine in aDefines 
         SET SECTION "Default" ENTRY "DEF" + AllTrim( Str( aDefine:__EnumIndex() ) ) ;
            OF oIni TO AllTrim( aDefine[ 1 ] )   
         SET SECTION "Default" ENTRY "DEFVALUE" + AllTrim( Str( aDefine:__EnumIndex() ) ) ;
            OF oIni TO AllTrim( aDefine[ 2 ] )   
      next     
 
      SET SECTION "Default" ENTRY "DEF" + AllTrim( Str( Len( aDefines ) + 1 ) ) ;
         OF oIni TO ""   
      SET SECTION "Default" ENTRY "DEFVALUE" + AllTrim( Str( Len( aDefines ) + 1 ) ) ;
         OF oIni TO ""   
   ENDINI

return nil
 
//----------------------------------------------------------------------------// 
 
function LoadPreferences()
 
   local oIni, cDefineName, cDefineValue, n

   if File( "vmh.ini" )
      INI oIni FILE "vmh.ini"
         GET lFLH       SECTION "Default" ENTRY "FLH"       DEFAULT .T.   OF oIni
         GET cHbmkPath  SECTION "Default" ENTRY "HbmkPath" ;
            DEFAULT cHbmkPath OF oIni
         GET cFLHPath   SECTION "Default" ENTRY "FLHPath"  DEFAULT "/fivelinux" OF oIni
      ENDINI
 
      GET cDefineName SECTION "Default" ;
         ENTRY "DEF1" OF oIni
      GET cDefineValue SECTION "Default" ;
         ENTRY "DEFVALUE1" OF oIni
 
      aDefines = {}   
 
      n = 1   
 
      while ! Empty( cDefineName )
         AAdd( aDefines, { cDefineName, cDefineValue } )
 
         GET cDefineName SECTION "Default" ;
            ENTRY "DEF" + AllTrim( Str( ++n ) ) OF oIni
         GET cDefineValue SECTION "Default" ;
            ENTRY "DEFVALUE" + AllTrim( Str( n ) ) OF oIni
      end         
   endif
 
return nil
 
//----------------------------------------------------------------------------// 
 
function SaveProject()
 
   local oIni, aFile
 
   INI oIni FILE "vmh.ini"
      SET SECTION "Project" ENTRY "PrgMain" OF oIni TO cPrgName
 
      for each aFile in aPRGs
         SET SECTION "Project" ENTRY "PRG" + AllTrim( Str( aFile:__enumIndex() ) ) ;
            OF oIni TO aFile[ 1 ]
      next   
 
      for each aFile in aCs
         SET SECTION "Project" ENTRY "C" + AllTrim( Str( aFile:__enumIndex() ) ) ;
            OF oIni TO aFile[ 1 ]
      next   
 
      for each aFile in aOBJs
         SET SECTION "Project" ENTRY "OBJ" + AllTrim( Str( aFile:__enumIndex() ) ) ;
            OF oIni TO aFile[ 1 ]
      next   
 
      for each aFile in aLIBs
         SET SECTION "Project" ENTRY "LIB" + AllTrim( Str( aFile:__enumIndex() ) ) ;
            OF oIni TO aFile[ 1 ]
      next   
 
      for each aFile in aRCs
         SET SECTION "Project" ENTRY "RC" + AllTrim( Str( aFile:__enumIndex() ) ) ;
            OF oIni TO aFile[ 1 ]
      next   
 
   ENDINI
 
return nil 
 
//----------------------------------------------------------------------------// 

function LoadProject()
 
   local oIni, cFileName, m, n
 
   if File( "vmh.ini" )
      INI oIni FILE "vmh.ini"
 
         GET cPrgName SECTION "Project" ENTRY "PrgMain" OF oIni
 
         for m = 1 to 5
            GET cFileName SECTION "Project" ;
               ENTRY { "PRG1", "C1", "OBJ1", "LIB1", "RC1" }[ m ] OF oIni
 
            if ! Empty( cFileName )
               do case
                  case m == 1
                       aPrgs = {}
 
                  case m == 2
                       aCs = {}
 
                  case m == 3 
                       aObjs = {}
 
                  case m == 4 
                       aLibs = {}
 
                  case m == 5 
                       aRcs = {}
               endcase                            
            endif   
 
            n = 1
            while ! Empty( cFileName )
               AAdd( { aPRGs, aCs, aObjs, aLibs, aRCs }[ m ],;
                     { cFileName, Directory( cFileName )[ 1 ][ 2 ],;
                                  Directory( cFileName )[ 1 ][ 3 ] } )
               GET cFileName SECTION "Project" ;
                  ENTRY { "PRG", "C", "OBJ", "LIB", "RC" }[ m ] + AllTrim( Str( ++n ) ) OF oIni                           
            end
         next
      ENDINI 
   endif
 
return nil 
 
//----------------------------------------------------------------------------//                  
