#include <hbapi.h>

#define IF(x,y,z) ((x)?(y):(z))
	
//----------------------------------------------------------------------------//

char * StrToken( char * szText, int wOcurrence, unsigned char bSeparator, int * pwLen )
{
   int wStart, wEnd = 0, wCounter = 0;

   if( ! bSeparator )
     bSeparator = ' ';

   do {
      wStart = wEnd;

      if( bSeparator != ' ' )
      {
         if( szText[ wStart ] == bSeparator )
            wStart++;
      }
      else
      {
         while( szText[ wStart ] && szText[ wStart ] == bSeparator )
            wStart++;
      }

      if( szText[ wStart ] && szText[ wStart ] != bSeparator )
      {
         wEnd = wStart + 1;

         while( szText[ wEnd ] && szText[ wEnd ] != bSeparator )
            wEnd++;
      }
      else
         wEnd = wStart;

   } while( wCounter++ < wOcurrence - 1 && szText[ wEnd ] );

   * pwLen = wEnd - wStart;

   if( wCounter < wOcurrence )
      * pwLen = 0;

   return szText + wStart;
}

//----------------------------------------------------------------------------//

HB_FUNC( STRTOKEN )  // ( cText, nOcurrence, cSepChar ) --> cToken
{
   int wLen;
   char * szToken = StrToken( ( char * ) hb_parc( 1 ), hb_parni( 2 ),
                             ( unsigned char ) ( IF( HB_ISCHAR( 3 ) && ( hb_pcount() > 2 ),
                                 * hb_parc( 3 ), 0 ) ), &wLen );

   hb_retclen( szToken, wLen );
}

//----------------------------------------------------------------------------//

HB_FUNC( STRCHAR ) // cText, nCharPos  --> cChar
{
   hb_retclen( hb_parc( 1 ) + hb_parni( 2 ) - 1, 1 );
}

//----------------------------------------------------------------------------//

HB_FUNC( STRBYTE ) // pStr, nunsigned charPos, [ nValue ]  --> nValue
{
   if( hb_pcount() > 2 ) // Assign
      * ( ( ( unsigned char * ) hb_parnl( 1 ) ) + hb_parnl( 2 ) - 1 ) = hb_parnl( 3 );
   else               // Retrieve
      hb_retni( * ( ( ( unsigned char * ) hb_parnl( 1 ) ) + hb_parnl( 2 ) - 1 ) );
}

//----------------------------------------------------------------------------//

HB_FUNC( STRCHARCOUNT ) // cString, cChar --> nTimes
{
   unsigned char * pString = ( unsigned char * ) hb_parc( 1 );
   unsigned char * pChar   = ( unsigned char * ) hb_parc( 2 );
   int wLen = hb_parclen( 1 );
   int w, wCount = 0;

   for( w = 0; w <= wLen - 1; w++ )
      if( pString[ w ] == pChar[ 0 ] )
         wCount++;

   hb_retnl( wCount );
}

//----------------------------------------------------------------------------//

HB_FUNC( STRCPY ) // punsigned char, punsigned char --> punsigned char
{
   unsigned char * pDest   = ( unsigned char * ) hb_parnl( 1 );
   unsigned char * pSource = ( unsigned char * ) hb_parnl( 2 );

   while( * pSource )          // Keep this here to manage strings > 64 ks!!!
      * pSource++ = * pDest++;

   hb_retnl( ( HB_LONG ) pDest );
}

//----------------------------------------------------------------------------//

HB_FUNC( STRPTR )                // cString --> pString
{
   hb_retnl( ( HB_LONG ) hb_parc( 1 ) );
}

//----------------------------------------------------------------------------//
