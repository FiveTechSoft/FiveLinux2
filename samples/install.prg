// Harbour setup for Linux  (FiveLinux distribution)

#include "FiveLinux.ch"

function Main()

   local oDlg, oBtnOk, oBtnQuit, nFile := 0, nFiles := 0
   local oSayName, oMeter1, oMeter2

   DEFINE DIALOG oDlg TITLE "Harbour setup (FiveLinux distribution)"

   @ 2, 1 SAY "This application will install Harbour for Linux" + ;
      " on your computer at:" OF oDlg SIZE 450, 20

   @ 5, 1 SAY + GetEnv( "HOME" ) + "/harbour" OF oDlg SIZE 200, 20

   @ 8, 2 GROUP LABEL "Progress" OF oDlg SIZE 480, 170

   @ 10, 2 SAY oSayName PROMPT "   " OF oDlg SIZE 150, 20

   @ 12, 4 METER oMeter1 VAR nFile TOTAL 100 OF oDlg SIZE 440, 25

   @ 17, 4 METER oMeter2 VAR nFiles TOTAL 100 OF oDlg SIZE 440, 25

   @ 21, 30 BUTTON oBtnOk PROMPT "" IMAGE "gtk-ok" OF oDlg ;
      ACTION ( oBtnOk:Disable(), oBtnQuit:Disable(),;
               Install( oSayName, oMeter1, oMeter2 ), MsgInfo( "done!" ),;
	       oDlg:bValid := nil, oBtnQuit:Enable() )

   oBtnOk:cToolTip = "starts the installation"

   @ 21, 40 BUTTON oBtnQuit PROMPT "" IMAGE "gtk-quit" OF oDlg ;
      ACTION oDlg:End()

   @ 27, 4 BUTTON "www.harbour-project.org" OF oDlg SIZE 150, 25 ;
      ACTION WinExec( "mozilla", "www.harbour-project.org" )

   @ 27, 32 BUTTON "www.fivetechsoft.com" OF oDlg SIZE 150, 25 ;
      ACTION ( WinExec( "mozilla", "www.fivetechsoft.com" ),;
               MsgInfo( "This GUI setup has been built using FiveLinux" ) )

   ACTIVATE DIALOG oDlg CENTERED ;
      VALID MsgYesNo( "Are you sure you want to cancel the installation ?" )

return nil

function Install( oSayName, oMeter1, oMeter2 )

   local cData := MemoRead( "harbour.bin" )
   local cHeader := SubStr( cData, 1, At( "*", cData ) - 1 )
   local nLines := MLCount( cHeader )
   local cName, nBufLen, nSize
   local cBuffer := SubStr( cData, At( "*", cData ) + 1 )
   local cFile, n, nPos := 1

   MakeDir( GetEnv( "HOME" ) + "/harbour" )
   MakeDir( GetEnv( "HOME" ) + "/harbour/bin" )
   MakeDir( GetEnv( "HOME" ) + "/harbour/lib" )
   MakeDir( GetEnv( "HOME" ) + "/harbour/include" )
   MakeDir( GetEnv( "HOME" ) + "/harbour/samples" )

   oMeter2:nTotal = Len( cBuffer )

   for n = 1 to nLines
      oMeter1:Set( 0 )
      cLine = MemoLine( cHeader,, n )
      cName = __StrToken( cLine, 1, "," )
      oSayName:SetText( cName )
      nBufLen = Val( __StrToken( cLine, 2, "," ) )
      nSize = Val( __StrToken( cLine, 3, "," ) )
      cFile = SubStr( cBuffer, nPos, nSize )
      cFile = HB_Uncompress( nBufLen, cFile )
      nPos += nSize
      oMeter1:nTotal = nSize
      oMeter1:Set( nSize )
      oMeter2:Set( Min( nPos, Len( cBuffer ) ) )
      SysRefresh()
      MemoWrit( GetEnv( "HOME" ) + "/harbour/" + cName, cFile )
      if SubStr( cName, At( "/", cName ) + 1 ) == "harbour" .or. ;
         SubStr( cName, At( "/", cName ) + 1 ) == "build.sh"
         SetExecutable( GetEnv( "HOME" ) + "/harbour/" + cName )
      endif
   next

return nil

function HB_UnCompress()

return nil
