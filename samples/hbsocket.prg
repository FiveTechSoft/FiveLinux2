#include "FiveLinux.ch"
#include "hbsocket.ch"

function Main()

   local oWA := HB_WhatsApp():New()

   ? oWA:Connect()
   oWA:Login()

   ? sprintf( "%04x%04x-%04x-%04x-%04x-%04x%04x%04x",;
              hb_Random( 0, 0xffff ), hb_Random( 0, 0xffff ),;
              hb_Random( 0, 0xffff ),;
              hb_BitOr( hb_Random( 0, 0x0fff ), 0x4000 ),;
              hb_BitOr( hb_Random( 0, 0x3fff ), 0x8000 ),;
              hb_Random( 0, 0xffff ), hb_Random( 0, 0xffff ), hb_Random( 0, 0xffff ) )

   ? hb_strformat( "%04x%04x-%04x-%04x-%04x-%04x%04x%04x",;
              hb_Random( 0, 0xffff ), hb_Random( 0, 0xffff ),;
              hb_Random( 0, 0xffff ),;
              hb_BitOr( hb_Random( 0, 0x0fff ), 0x4000 ),;
              hb_BitOr( hb_Random( 0, 0x3fff ), 0x8000 ),;
              hb_Random( 0, 0xffff ), hb_Random( 0, 0xffff ), hb_Random( 0, 0xffff ) )

return nil

function NumToHex()
return nil

CLASS HB_WhatsApp

   DATA  pSocket
   DATA  cHost  INIT "bin-short.whatsapp.net"
   DATA  nPort  INIT 5222
   DATA  cIP
   DATA  aResArray
   DATA  cMsg
   DATA  _Incomplete_message

   METHOD New()
   METHOD Connect()
   METHOD Login()
   
   METHOD Read()
   METHOD Send( cData )

   METHOD _Identify( cStr )
   METHOD _Is_Full_Msg( cStr )

   DESTRUCTOR Destroy()

ENDCLASS

METHOD New() CLASS HB_WhatsApp

   ::cIP = hb_socketGetHosts( ::cHost )[ 1 ]
   ::pSocket = hb_socketOpen()

return self

METHOD Connect() CLASS HB_WhatsApp

return hb_socketConnect( ::pSocket, { HB_SOCKET_AF_INET, ::cIP, ::nPort } )

static function StrToHex( cStr )

   local n, cHex := "" 
   
   for n = 1 to Len( cStr )
      cHex += "0x" + NumToHex( Asc( SubStr( cStr, n, 1 ) ) )
      if n < Len( cStr )
         cHex += ", "
      endif   
   next
   
return cHex         

METHOD Login() CLASS HB_WhatsApp

   local cBuffer, cResponse

   ? ::Send( "WA" + Chr( 0x01 ) + Chr( 0 ) + Chr( 0 ) + ;
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

   ? cResponse

return nil

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
              ::accinfo = ::parse_account_info( cV )

         case cRcvdType == "last_seen"
              ::lastseen = ::parse_last_seen( cV )
      endcase
   next

return cBuffer

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

   elseif StartsWith( cStr, cMsg_identifier, 3 )

      if EndsWith( cStr, cServer_delivery_identifier )
         return "server_delivery_report"

      elseif EndsWith( cStr, cClient_delivery_identifier ) 
         return "client_delivery_report"

      else
         return "msg"

      endif 

   elseif StartsWith( cStr, cAcc_info_iden, 3 )
      return "account_info"

   elseif StartsWith( cStr, cLast_seen_ident, 3 ) .and. cLast_seen_ident2 $ cStr
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

#pragma BEGINDUMP

HB_FUNC( SPRINTF )
{
   char buffer[ 200 ];
   int i;

   switch( hb_pcount() )
   {
      case 0:
           i = 0;
           break;

      case 1:
           i = sprintf( buffer, ( char * ) hb_parc( 1 ) );
           break;

      case 2:
           i = sprintf( buffer, ( char * ) hb_parc( 1 ), hb_parnl( 2 ) );
           break;

      case 3:
           i = sprintf( buffer, ( char * ) hb_parc( 1 ), hb_parnl( 2 ), hb_parnl( 3 ) );
           break;

      case 4:
           i = sprintf( buffer, ( char * ) hb_parc( 1 ), hb_parnl( 2 ), hb_parnl( 3 ), hb_parnl( 4 ) );
           break;

      case 5:
           i = sprintf( buffer, ( char * ) hb_parc( 1 ), hb_parnl( 2 ), hb_parnl( 3 ), hb_parnl( 4 ), hb_parnl( 5 ) );
           break;

      case 6:
           i = sprintf( buffer, ( char * ) hb_parc( 1 ), hb_parnl( 2 ), hb_parnl( 3 ), hb_parnl( 4 ), hb_parnl( 5 ),
                        hb_parnl( 6 ) );
           break;

      case 7:
           i = sprintf( buffer, ( char * ) hb_parc( 1 ), hb_parnl( 2 ), hb_parnl( 3 ), hb_parnl( 4 ), hb_parnl( 5 ),
                        hb_parnl( 6 ), hb_parnl( 7 ) );
           break;

      case 8:
           i = sprintf( buffer, ( char * ) hb_parc( 1 ), hb_parnl( 2 ), hb_parnl( 3 ), hb_parnl( 4 ), hb_parnl( 5 ),
                        hb_parnl( 6 ), hb_parnl( 7 ), hb_parnl( 8 ) );
           break;

      case 9:
           i = sprintf( buffer, ( char * ) hb_parc( 1 ), hb_parnl( 2 ), hb_parnl( 3 ), hb_parnl( 4 ), hb_parnl( 5 ),
                        hb_parnl( 6 ), hb_parnl( 7 ), hb_parnl( 8 ), hb_parnl( 9 ) );
           break;
   }
   
   hb_retclen( buffer, i );
}

#pragma ENDDUMP
