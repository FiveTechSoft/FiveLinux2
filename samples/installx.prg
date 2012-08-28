// xHarbour setup for Linux  (FiveLinux distribution)

#include "FiveLinux.ch"

function Main()

   local oDlg, oBtnOk, oBtnQuit, nFile := 0, nFiles := 0
   local oSayName, oMeter1, oMeter2

   DEFINE DIALOG oDlg TITLE "xHarbour setup (FiveLinux distribution)"

   @ 2, 1 SAY "This application will install xHarbour for Linux" + ;
      " on your computer at:" OF oDlg SIZE 400, 20

   @ 5, 1 SAY + GetEnv( "HOME" ) + "/xharbour" OF oDlg SIZE 200, 20

   @ 8, 2 GROUP LABEL "Progress" OF oDlg SIZE 480, 170

   @ 10, 2 SAY oSayName PROMPT "   " OF oDlg SIZE 150, 20

   @ 12, 4 METER oMeter1 VAR nFile TOTAL 100 OF oDlg SIZE 440, 25

   @ 17, 4 METER oMeter2 VAR nFiles TOTAL 100 OF oDlg SIZE 440, 25

   @ 21, 30 BUTTON oBtnOk PROMPT "" RESOURCE "gtk-ok" OF oDlg ;
      ACTION ( oBtnOk:Disable(), oBtnQuit:Disable(),;
               Install( oSayName, oMeter1, oMeter2 ), MsgInfo( "done!" ),;
	       oDlg:bValid := nil, oBtnQuit:Enable() )

   oBtnOk:cToolTip = "starts the installation"

   @ 21, 40 BUTTON oBtnQuit PROMPT "" RESOURCE "gtk-quit" OF oDlg ;
      ACTION oDlg:End()

   @ 27, 4 BUTTON "www.xharbour.org" OF oDlg SIZE 150, 25 ;
      ACTION WinExec( "mozilla", "www.xharbour.org" )

   @ 27, 32 BUTTON "www.fivetechsoft.com" OF oDlg SIZE 150, 25 ;
      ACTION ( WinExec( "mozilla", "www.fivetechsoft.com" ),;
               MsgInfo( "This GUI setup has been built using FiveLinux" ) )

   ACTIVATE DIALOG oDlg CENTERED ;
      VALID MsgYesNo( "Are you sure you want to cancel the installation ?" )

return nil

function Install( oSayName, oMeter1, oMeter2 )

   local cData := MemoRead( "xharbour.bin" )
   local cHeader := SubStr( cData, 1, At( "*", cData ) - 1 )
   local nLines := MLCount( cHeader )
   local cName, nBufLen, nSize
   local cBuffer := SubStr( cData, At( "*", cData ) + 1 )
   local cFile, n, nPos := 1

   MakeDir( GetEnv( "HOME" ) + "/xharbour" )
   MakeDir( GetEnv( "HOME" ) + "/xharbour/bin" )
   MakeDir( GetEnv( "HOME" ) + "/xharbour/lib" )
   MakeDir( GetEnv( "HOME" ) + "/xharbour/include" )
   MakeDir( GetEnv( "HOME" ) + "/xharbour/samples" )

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
      MemoWrit( GetEnv( "HOME" ) + "/xharbour/" + cName, cFile )
      if SubStr( cName, At( "/", cName ) + 1 ) == "harbour" .or. ;
         SubStr( cName, At( "/", cName ) + 1 ) == "build.sh"
         SetExecutable( GetEnv( "HOME" ) + "/xharbour/" + cName )
      endif
   next

return nil
