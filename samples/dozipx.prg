#include "FiveLinux.ch"

function Main()

   local cFile := MemoRead( "/home/antonio/xharbour/bin/harbour" )
   local aLib  := Directory( "/home/antonio/xharbour/lib/*.*" )
   local aInc  := Directory( "/home/antonio/xharbour/include/*.*" )
   local aSam  := Directory( "/home/antonio/xharbour/samples/*.*" )
   local cOut  := "", cInfo := "", n, nBufLen, cComp

   nBufLen = HB_CompressBufLen( Len( cFile ) )
   cComp = HB_Compress( cFile )
   cInfo += "bin/harbour,"
   cInfo += AllTrim( Str( nBufLen ) ) + ","
   cInfo += AllTrim( Str( Len( cComp ) ) ) + HB_OsNewLine()
   cOut += cComp

   for n = 1 to Len( aLib )
      cFile   = MemoRead( "/home/antonio/xharbour/lib/" + aLib[ n ][ 1 ] )
      nBufLen = HB_CompressBufLen( Len( cFile ) )
      cComp   = HB_Compress( cFile )
      cInfo += "lib/" + aLib[ n ][ 1 ] + ","
      cInfo += AllTrim( Str( nBufLen ) ) + ","
      cInfo += AllTrim( Str( Len( cComp ) ) ) + HB_OsNewLine()
      cOut += cComp
   next

   for n = 1 to Len( aInc )
      cFile   = MemoRead( "/home/antonio/xharbour/include/" + aInc[ n ][ 1 ] )
      nBufLen = HB_CompressBufLen( Len( cFile ) )
      cComp   = HB_Compress( cFile )
      cInfo += "include/" + aInc[ n ][ 1 ] + ","
      cInfo += AllTrim( Str( nBufLen ) ) + ","
      cInfo += AllTrim( Str( Len( cComp ) ) ) + HB_OsNewLine()
      cOut += cComp
   next

   for n = 1 to Len( aSam )
      cFile   = MemoRead( "/home/antonio/xharbour/samples/" + aSam[ n ][ 1 ] )
      nBufLen = HB_CompressBufLen( Len( cFile ) )
      cComp   = HB_Compress( cFile )
      cInfo += "samples/" + aSam[ n ][ 1 ] + ","
      cInfo += AllTrim( Str( nBufLen ) ) + ","
      cInfo += AllTrim( Str( Len( cComp ) ) ) + HB_OsNewLine()
      cOut += cComp
   next

   cInfo += "*"
   cOut = cInfo + cOut

   MemoWrit( "xharbour.bin", cOut )
   MsgInfo( "compression done!" )

   Install( cOut )

return nil

function Install( cData )

   local cHeader := SubStr( cData, 1, At( "*", cData ) - 1 )
   local nLines := MLCount( cHeader )
   local cName, nBufLen, nSize
   local cBuffer := SubStr( cData, At( "*", cData ) + 1 )
   local cFile, n, nPos := 1

   MakeDir( GetEnv( "HOME" ) + "/_xharbour" )
   MakeDir( GetEnv( "HOME" ) + "/_xharbour/bin" )
   MakeDir( GetEnv( "HOME" ) + "/_xharbour/lib" )
   MakeDir( GetEnv( "HOME" ) + "/_xharbour/include" )
   MakeDir( GetEnv( "HOME" ) + "/_xharbour/samples" )

   for n = 1 to nLines
      cLine = MemoLine( cHeader,, n )
      cName = __StrToken( cLine, 1, "," )
      nBufLen = Val( __StrToken( cLine, 2, "," ) )
      nSize = Val( __StrToken( cLine, 3, "," ) )
      cFile = SubStr( cBuffer, nPos, nSize )
      cFile = HB_Uncompress( nBufLen, cFile )
      nPos += nSize
      MemoWrit( GetEnv( "HOME" ) + "/_xharbour/" + cName, cFile )
   next

return nil
