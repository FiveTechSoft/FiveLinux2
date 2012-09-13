#include "FiveLinux.ch"
#include "hbsocket.ch"

function Main()
                                                                   
   // local oWA := HB_WhatsApp():New( "34684078311", hb_md5( StrRev( "AndroidIMEI" ) ), "YourNickname" )
   local oWA := HB_WhatsApp():New( "34XXXXXXXXX", hb_md5( "AA:BB:CC:DD:EE:FFAA:BB:CC:DD:EE:FF" ), "YourNickname" )

   if oWA:Connect()
      oWA:Login()

      ? oWA:cAccount_status, oWA:cAccount_kind, oWA:cAccount_creation, oWA:cAccount_expiration
   
      oWA:RequestLastSeen( "34670463032" )
      ? oWA:LastSeen[ 'seconds_ago' ]
   
      oWA:Message( Str( TS2Num() ), "34XXXXXXXXX", "Testing" )
   else
      MsgInfo( "can't connect" )
   endif

return nil

#IFDEF __XHARBOUR__
  #xtranslate hb_DateTime([<x,...>])          => DateTime(<x>)
  #xtranslate hb_tstostr([<x>])               => TToS(<x>)
  #xtranslate hb_stot([<x>])                  => SToT(<x>)
  #xtranslate hb_ttod([<x>])                  => TToD(<x>)
  #xtranslate hb_hour([<x>])                  => Hour(<x>)
  #xtranslate hb_minute([<x>])                => Minute(<x>)
  #xtranslate hb_sec([<x>])                   => Secs(<x>)
  #xtranslate hb_NumToHex([<x>])              => NumToHex(<x>)
  #xtranslate hb_StrFormat([<x,...>])         => StrFormat(<x>)
  #xtranslate <x>:__EnumIndex                 => hb_EnumIndex
#ENDIF

CLASS HB_WhatsApp

   DATA  cAccount_status, cAccount_kind, cAccount_creation, cAccount_expiration
   DATA  cNumber, cPassword, cNickname
   DATA  pSocket
   DATA  cServer INIT "s.whatsapp.net"
   DATA  cHost   INIT "bin-short.whatsapp.net"
   DATA  cRealm  INIT "s.whatsapp.net"
   DATA  nPort   INIT 5222
   DATA  cIP
   DATA  cQop    INIT "auth"
   DATA  cDigest_Uri INIT "xmpp/s.whatsapp.net"
   DATA  aResArray
   DATA  cMsg
   DATA  _Incomplete_message
   DATA  LastSeen

   METHOD New( cNumber, cPassword, cNickname )
   METHOD Connect()
   METHOD Login()
   METHOD Message( cMmsgid, cTo, cTxt )
   METHOD Read()
   METHOD Send( cData )
   METHOD parse_last_seen( cMsg )
   METHOD parse_received_message( cMsg )
   METHOD RequestLastSeen( mobile )

   METHOD _Authenticate( cNonce, cNC )
   METHOD _Identify( cStr )
   METHOD _Is_Full_Msg( cStr )
   METHOD parse_account_info( msg )

   METHOD Destroy()

ENDCLASS

METHOD New( cNumber, cPassword, cNickname ) CLASS HB_WhatsApp

   ::cIP = hb_socketGetHosts( ::cHost )[ 1 ]
   ::pSocket = hb_socketOpen()

   ::cNumber   = cNumber
   ::cPassword = cPassword
   ::cNickname = cNickname

return self

METHOD Connect() CLASS HB_WhatsApp

return hb_socketConnect( ::pSocket, { HB_SOCKET_AF_INET, ::cIP, ::nPort } )

static function StrToHex( cStr )

   local n, cHex := "" 
   
   for n = 1 to Len( cStr )
      cHex += "0x" + PadL( hb_NumToHex( Asc( SubStr( cStr, n, 1 ) ) ), "0", 2 )
      if n < Len( cStr )
         cHex += ", "
      endif   
   next
   
return cHex         

static function random_uuid()

return hb_strformat( "%04x%04x-%04x-%04x-%04x-%04x%04x%04x",;
                     hb_Random( 0, 0xffff ), hb_Random( 0, 0xffff ),;
                     hb_Random( 0, 0xffff ),;
                     hb_BitOr( Int( hb_Random( 0, 0x0fff ) ), 0x4000 ),;
                     hb_BitOr( Int( hb_Random( 0, 0x3fff ) ), 0x8000 ),;
                     hb_Random( 0, 0xffff ), hb_Random( 0, 0xffff ), hb_Random( 0, 0xffff ) )
              
METHOD Login() CLASS HB_WhatsApp

   local cBuffer, cResponse, aArrResponse, hAuthData, cValue, aResData, cResData

   ::Send( "WA" + Chr( 0x01 ) + Chr( 0x01 ) + Chr( 0 ) + ;
             Chr( 0x19 ) + Chr( 0xF8 ) + Chr( 0x05 ) + Chr( 0x01 ) + ;
             Chr( 0xA0 ) + Chr( 0x8A ) + Chr( 0x84 ) + Chr( 0xFC ) + ;
             Chr( 0x11 ) + "iPhone-2.6.9-5222" + ;
             Chr( 0 ) + Chr( 0x08 ) + Chr( 0xF8 ) + Chr( 0x02 ) + ;
             Chr( 0x96 ) + Chr( 0xF8 ) + Chr( 0x01 ) + Chr( 0xF8 ) + ;
             Chr( 0x01 ) + Chr( 0x7E ) + Chr( 0 ) + Chr( 0x07 ) + Chr( 0xF8 ) + ;
             Chr( 0x05 ) + Chr( 0x0F ) + Chr( 0x5A ) + Chr( 0x2A ) + ;
             Chr( 0xBD ) + Chr( 0xA7 ) )

   cBuffer = ::Read()
   cResponse = hb_base64decode( SubStr( cBuffer, 27 ) )
   aArrResponse = HB_ATokens( cResponse, "," )
   hAuthData = {=>}
   
   for each cValue in aArrResponse
      aResData = hb_ATokens( cValue, "=" )
      hAuthData[ aResData[ 1 ] ] = StrTran( aResData[ 2 ], '"', "" )
   next    
   
   cResData = ::_Authenticate( hAuthData[ "nonce" ] ) 
   cResponse = Chr( 0x01 ) + Chr( 0x31 ) + Chr( 0xF8 ) + Chr( 0x04 ) + Chr( 0x86 ) + ;
               Chr( 0xBD ) + Chr( 0xA7 ) + Chr( 0xFD ) + Chr( 0 ) + Chr( 1 ) + Chr( 0x28 ) + ;
               hb_base64encode( cResData )
   ::Send( cResponse )
   cBuffer = ::Read()
   ::Read()
   cResponse = Chr( 0 ) + Chr( 8 + Len( ::cNickname ) ) + Chr( 0xF8 ) + Chr( 5 ) + Chr( 0x74 ) + ;
               Chr( 0xA2 ) + Chr( 0xA3 ) + Chr( 0x61 ) + Chr( 0xFC ) + Chr( Len( ::cNickName ) ) + ;
               ::cNickName + Chr( 0 ) + Chr( 0x15 ) + Chr( 0xF8 ) + Chr( 6 ) + Chr( 0x48 ) + ;
               Chr( 0x43 ) + Chr( 5 ) + Chr( 0xA2 ) + Chr( 0x3A ) + Chr( 0xF8 ) + Chr( 1 ) + ;
               Chr( 0xF8 ) + Chr( 4 ) + Chr( 0x7B ) + Chr( 0xBD ) + Chr( 0x4D ) + Chr( 0xF8 ) + ;
               Chr( 1 ) + Chr( 0xF8 ) + Chr( 3 ) + Chr( 0x55 ) + Chr( 0x61 ) + Chr( 0x24 ) + ;
               Chr( 0 ) + Chr( 0x12 ) + Chr( 0xF8 ) + Chr( 8 ) + Chr( 0x48 ) + Chr( 0x43 ) + ;
               Chr( 0xFC ) + Chr( 1 ) + Chr( 0x32 ) + Chr( 0xA2 ) + Chr( 0x3A ) + Chr( 0xA0 ) + ;
               Chr( 0x8A ) + Chr( 0xF8 ) + Chr( 1 ) + Chr( 0xF8 ) + Chr( 3 ) + Chr( 0x1F ) + ;
               Chr( 0xBD ) + Chr( 0xB1 )
   ::Send( cResponse )
   ::Read()    
   
return nil

METHOD _Authenticate( cNonce, cNC ) CLASS HB_WhatsApp

   local cCNonce := random_uuid()
   local cA1 := hb_StrFormat( "%s:%s:%s", ::cNumber, ::cServer, ::cPassword )
   local cA2, cPassword

   if cNC == nil
      cNC = "00000001"
   endif
   
   cA1 = pack_h32( hb_md5( cA1 ) ) + ":" + cNonce + ":" + cCNonce   
   cA2 = "AUTHENTICATE:" + ::cDigest_Uri
   cPassword = hb_md5( cA1 ) + ":" + cNonce + ":" + cNC + ":" + cCNonce + ":" + ::cQop + ;
               ":" + hb_md5( cA2 )
   cPassword = hb_md5( cPassword )            
   
return hb_StrFormat( 'username="%s",realm="%s",nonce="%s",cnonce="%s",nc=%s,qop=%s,digest-uri="%s",response=%s,charset=utf-8',;
                     ::cNumber, ::cRealm, cNonce, cCnonce, cNC, ::cQop, ::cDigest_Uri, cPassword )   
 
METHOD Message( cMsgid, cTo, cTxt ) CLASS HB_WhatsApp

   local lLong_txt_bool := isShort( cTxt )
   local cStream , cMsg, cContent, cTxt_length
   local cTo_length
   local cMsgid_length
   local cTotal_length
   
   cTo_length = Chr( Len( cTo ) )
   cMsgid_length = Chr( Len( cMsgid ) )
   cTxt_length = Chr( Len( cTxt ) )
   
   cContent = Chr( 0xF8 ) + Chr( 0x08 ) + Chr( 0x5D ) + Chr( 0xA0 ) + Chr( 0xFA ) + Chr( 0xFC ) + cTo_length
   cContent += cTo
   cContent += Chr( 0x8A ) + Chr( 0xA2 ) + Chr( 0x1B ) + Chr( 0x43 ) + Chr( 0xFC ) + cMsgid_length
   cContent += cMsgid
   cContent += Chr( 0xF8 ) + Chr( 0x02 ) + Chr( 0xF8 ) + Chr( 0x04 ) + Chr( 0xBA ) + Chr( 0xBD ) + Chr( 0x4F) + ;
               Chr( 0xF8 ) + Chr( 0x01 ) + Chr( 0xF8 ) + Chr( 0x01 ) + Chr( 0x8C ) + Chr( 0xF8 ) + Chr( 0x02 ) + Chr( 0x16 )

   if ! lLong_txt_bool
      cContent += Chr( 0xFD ) + Chr( 0 ) + cTxt_length
   else
      cContent += Chr( 0xFC ) + cTxt_length
   endif
  
   cContent += cTxt
 
   cTotal_length = Chr( Len( cContent ) )
   
   if Len( cTotal_length ) == 1
      cTotal_length = Chr( 0 ) + cTotal_length
   endif
    
   cMsg := cTotal_length + cContent 
   
   cStream := ::Send( cMsg )
   ::Read()
   // ::Read()
   // ::Read()
        
Return nil
 
METHOD parse_received_message( cMsg ) CLASS HB_WhatsApp

   local message := { => }, nLength

   // RCVD MSG IN STRING 
   nLength = Asc( SubStr( cMsg, 1, 1 ) )
   message[ 'length' ] = nLength  // PACKET EXCLUDING 00 AND FIRST HEX SHOULD EQUAL THIS NUMBER
   
   cMsg = SubStr( cMsg, 3 )       // Remove Length & F8
   message[ 'sec_length' ] = Asc( SubStr( cMsg, 1, 1 ) )       // Length of something i dont know excatly what  
   cMsg = SubStr( cMsg, 6 )       // Remove Second Length ( 1 HEX ) , Remove XML Chrs ( 4 HEX )
   message[ 'from_number_length' ] = Asc( SubStr( cMsg, 1, 1 ) )
   
   cMsg = SubStr( cMsg, 2 )       // Remove Length
   message[ 'from_number' ] = SubStr( cMsg, 1, message[ 'from_number_length' ] )
   
   cMsg = SubStr( cMsg, message[ 'from_number_length' ] + 1 )             // Remove NUMBER
   cMsg = SubStr( cMsg,4 )       // Remove F8 & XML ( 2 HEX )
   message[ 'message_id_length' ] = Asc( SubStr( cMsg, 1, 1 ) )
   cMsg = Substr( cMsg, 2 )       // Remove Length
   message[ 'message_id' ] = SubStr( cMsg, 1, message[ 'message_id_length' ] )
   cMsg = SubStr( cMsg, message[ 'message_id_length' ] + 1 )
   cMsg = SubStr( cMsg, 5 )       // Remove XML ( 4 HEX )
   message[ 'timestamp_length' ] = Asc( SubStr( cMsg, 1, 1 ) )
   cMsg = SubStr( cMsg, 2 )       // Remove Length
   message[ 'timestamp' ] = Num2TS( Val( SubStr( cMsg, 1, message[ 'timestamp_length' ] ) ) )
   
   cmsg = SubStr( cMsg, message[ 'timestamp_length' ] + 1 )               // Remove Timestamp
   // Check for Retry header 
   if Substr( cMsg, 1, 1 ) == Chr( 0x88 )
      cMsg = SubStr( cMsg, 5 )       // Remove Retry Length , i dont think i will need it
   endif
   
   cmsg = Substr( cMsg, 10 )      // Remove XMPP XML and Name XML Headers 
   message[ 'sender_name_length' ] = Asc( SubStr( cMsg, 1, 1 ) )
   cmsg = SubStr( cMsg, 2 )       // Remove Length
   message[ 'sender_name' ] = SubStr( cMsg, 1, message[ 'sender_name_length' ] )
   
   cMsg = SubStr( cMsg, message[ 'sender_name_length' ] + 1 )   // Remove sender from msg
   cMsg = SubStr( cMsg, 10 )      // Remove body headers
   message[ 'body_txt_length' ] = Asc( SubStr( cMsg, 1, 1 ) )

   cMsg = SubStr( cMsg, 2 )       // Remove Length
   message[ 'body_txt' ] = SubStr( cMsg, 1, message[ 'body_txt_length' ] )

   cMsg = SubStr( cMsg, message[ 'body_txt_length' ] + 1 )  // Remove body txt
   cMsg = SubStr( cMsg, 10 )      // Remove XMPP XML and Name XML Headers 
   message[ 'time_length' ] = Asc( SubStr( cMsg, 1, 1 ) )

   cMsg = SubStr( cMsg, 2 )       // Remove Length
   message[ 'time' ] = SubStr( cMsg, 1, message[ 'time_length' ] )         
   cMsg = SubStr( cMsg, message[ 'time_length' ] + 1 )

   ? "From: " + message[ 'sender_name' ] + CRLF + ;
     "msg:  " + message[ 'body_txt' ] + CRLF + ;
     "date: " + message[ 'timestamp' ]
   
return message
               
METHOD Read() CLASS HB_WhatsApp

   local cBuffer := Space( 1024 ), cV, cRcvdType
   local nLen := hb_socketRecv( ::pSocket, @cBuffer )

   cBuffer = SubStr( cBuffer, 1, nLen )
   ::aResArray = HB_ATokens( cBuffer, Chr( 0 ) )
   // ? StrToHex( cBuffer )
   
   for each cV in ::aResArray 
      cRcvdType = ::_Identify( cV ) 

      // ? cRcvdType
      // ? StrToHex( cV )

      do case
         case cRcvdType == "incomplete_msg"
              ::_incomplete_message = cV

         case cRcvdType == "msg"
              ::cMsg = ::parse_received_message( cV )
         
         case cRcvdType == "account_info"
              ::parse_account_info( cV )

         case cRcvdType == "last_seen"
              ::lastseen = ::parse_last_seen( cV )
      endcase
   next

return cBuffer
    
METHOD parse_account_info( cMsg )

   local nAcst, nActkind
   local x := { => }
   local nCreation_timstamp_len, nExpr_length
   
    cMsg = SubStr( cMsg, 4 )        // Remove Length,F8,second length
    cMsg = SubStr( cMsg, 5 )        // Remove Success XML
    // Next should be status
    nAcst = Asc( SubStr( cMsg, 1, 1 ) ) 
    if nAcst == 0x09
       ::cAccount_status = 'active'
    else
       ::cAccount_status = 'inactive'
    endif
    cMsg = SubStr( cMsg, 3 )        // Remove status & KIND XML
    nActkind = Asc( SubStr( cMsg, 1, 1 ) )
    if nActkind == 0x37
       ::cAccount_kind = 'free'
    else 
       ::cAccount_kind = 'paid'
    endif
    cMsg = SubStr( cMsg, 4 )        // Remove XML
    nCreation_timstamp_len = Asc( SubStr( cMsg, 1, 1 ) ) // Should return 10 for the next few thousdands years
    cMsg = SubStr( cMsg, 2 )        // Remove Length
    ::cAccount_creation := Num2TS( Val( SubStr( cMsg, 1, nCreation_timstamp_len ) ) )
    cMsg = SubStr( cMsg, nCreation_timstamp_len + 1 )       // Remove Timestamp
    cMsg = SubStr( cMsg, 3 )        // Remove Expiration XML
    nExpr_length = Asc( SubStr( cMsg, 1, 1 ) ) // Should also be 10
    cMsg = SubStr( cMsg, 2 )        // Remove Length
    ::cAccount_expiration := Num2TS( Val( SubStr( cMsg, 1, nExpr_length ) ) )

return nil

METHOD RequestLastSeen( mobile ) CLASS HB_WhatsApp

   local mob_len, content, len, total_length, request, stream

   mob_len = Chr( Len( mobile ) )
   content = Chr( 0xF8 ) + Chr( 0x08 ) + Chr( 0x48 ) + Chr( 0x43 ) + Chr( 0xFC )
   content += Chr( 0x01 ) + Chr( 0x37 ) + Chr( 0xA2 ) + Chr( 0x3A ) + Chr( 0xA0 )
   content += Chr( 0xFA ) + Chr( 0xFC ) + mob_len
   content += mobile
   content += Chr( 0x8A ) + Chr( 0xF8 ) + Chr( 0x01 ) + Chr( 0xF8 ) + Chr( 0x03 )
   content += Chr( 0x7B ) + Chr( 0xBD ) + Chr( 0x4C )

   len = Len( content )
   total_length = Chr( len )

   request = Chr( 0 )
   request += total_length
   request += content
   stream  = ::Send( request )
   ::Read()
   ::Read()

return nil

METHOD parse_last_seen( cMsg ) CLASS HB_WhatsApp

   Local lastseen := {=>}, moblen, last_seen_len

   cMsg = SubStr( cMsg, 8 )  // Remove Some XML DATA
   moblen= Asc( SubStr( cMsg, 1, 1 ) )
   cMsg = SubStr( cMsg, 2 )  // Remove Length
   lastseen[ 'mobile' ] = SubStr( cMsg, 1, moblen )
   cMsg = SubStr( cMsg, moblen + 1 )
   cMsg = SubStr( cMsg, 17 ) // Remove Some More XML DATA
   last_seen_len = Asc( SubStr( cMsg, 1, 1 ) ) 
   cmsg = SubStr( cMsg, 2 )  // Remove Length
   lastseen[ 'seconds_ago' ] = SubStr( cMsg, 0, last_seen_len )

return lastseen

METHOD Send( cData ) CLASS HB_WhatsApp

return hb_socketSend( ::pSocket, cData )

static function StartsWith( cStr, cCompare, nPos )

return SubStr( cStr, nPos, Len( cCompare ) ) == cCompare

static function EndsWith( cStr, cCompare )

return Right( cStr, Len( cCompare ) ) == cCompare

METHOD _Identify( cStr ) CLASS HB_WhatsApp

   local cMsg_identifier := Chr( 0x5D ) + Chr( 0x38 ) + Chr( 0xFA ) + Chr( 0xFC ) 
   local cServer_delivery_identifier := Chr( 0x8C ) 
   local cClient_delivery_identifier := Chr( 0x7F ) + Chr( 0xBD ) + Chr( 0xAD )
   local cAcc_info_iden := Chr( 0x99 ) + Chr( 0xBD ) + Chr( 0xA7 ) + Chr( 0x94 )    
   local cLast_seen_ident := Chr( 0x48 ) + Chr( 0x38 ) + Chr( 0xFA ) + Chr( 0xFC )
   local cLast_seen_ident2 := Chr( 0x7B ) + Chr( 0xBD ) + Chr( 0x4C ) + Chr( 0x8B )
   
   if ! ::_is_full_msg( cStr )
      return "incomplete_msg"

   elseif StartsWith( cStr, cMsg_identifier, 4 )

      if EndsWith( cStr, cServer_delivery_identifier )
         return "server_delivery_report"

      elseif EndsWith( cStr, cClient_delivery_identifier ) 
         return "client_delivery_report"

      else
         return "msg"

      endif 

   elseif StartsWith( cStr, cAcc_info_iden, 4 )
      return "account_info"

   elseif StartsWith( cStr, cLast_seen_ident, 4 ) .and. cLast_seen_ident2 $ cStr
      return "last_seen"
   
   else
      return "other"

   endif

return nil

METHOD _Is_Full_Msg( cStr ) CLASS HB_WhatsApp

return Len( cStr ) == Asc( Left( cStr, 1 ) ) + 1

METHOD Destroy() CLASS HB_WhatsApp

   HB_SocketShutDown( ::pSocket )
   HB_SocketClose( ::pSocket )

   ::pSocket = nil

return nil

static function pack_h32( cString )
   
   local c := "", cLeter
   local nibbleshift := 4
   local n
   local nPos   := 0
   local aOut   := {}

   for each cLeter in cString
      n = asc( cLeter )
      if n >= asc( "0" ) .and. n <= asc( "9" )
         n -= asc( "0" )
      elseif n >= asc( "a" ) .and. n <= asc( "f" )
         n -= ( asc( "a" ) - 10 )
      elseif n >= asc( "F" ) .and. n <= asc( "F" )
         n -= ( asc( "A" ) - 10 )
      endif
      
      if cLeter:__enumindex() % 2 != 0
         AAdd( aOut, 0 )         
         nPos++
      endif
      
        aOut[ nPos ] = hb_BitOr( aOut[ nPos ], hb_BitShift( n, nibbleshift ) )
      
      nibbleshift = hb_BitAnd( ( nibbleshift + 4 ), 7 )

      if cLeter:__enumindex() % 2 == 0
         c += Chr( aOut[ nPos ] )
      endif      
      
   next

return c 

static function  Num2Days( timet )

return  (timet) / (24.0 * 60.0 * 60.0)

static function  Num2TS( n )
   local fecha, hour, min, sec, time, datetime
   local t2d := Num2Days( n )
   
   fecha = Num2Date( n )
   hour  = ( t2d - int( t2d ) ) * 24
   min   = ( hour - int( hour ) ) * 60
   sec   = ( min - int( min ) ) * 60
   time  = strzero( int( hour ), 2 ) + strzero( int( min ), 2 ) + strzero( int( sec ), 2 )
   datetime = dtos( fecha ) + time
   
return hb_tstostr( hb_stot( datetime ) )

static function Num2Date( n )

   local fecha
   local t2d := Num2Days( n )
   
   fecha := SToD( "19700101" ) + int( t2d )
   
return fecha

static function TS2Num( dt )

   local fecha   
   local nNum
   
   DEFAULT dt := hb_DateTime()
   
   nNum = ( hb_Hour( dt ) * 24 + hb_Minute( dt ) * 60 + hb_sec( dt ) * 60 ) / 86400
      
   nNum += ( hb_TToD( dt ) - SToD( "19700101" ) )
   
   nNum *= 86400 
   
   nNum = Int( nNum )
   
return nNum

static function isShort( str )

return Len( str ) < 256

#pragma BEGINDUMP

#include <hbapi.h>

HB_FUNC( STRREV )
{
   int iLen = hb_parclen( 1 ), i;
   char * buffer = ( char * ) hb_xgrab( iLen );
   
   for( i = 0; i < iLen; i++ )
      buffer[ i ] = hb_parc( 1 )[ iLen - i - 1 ];
      
   hb_retclen( buffer, iLen );
   hb_xfree( buffer );
}

#pragma ENDDUMP      
 
