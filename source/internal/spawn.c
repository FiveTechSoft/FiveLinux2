#include <hbapi.h>
#include <gtk/gtk.h>

HB_FUNC( WINEXEC )
{
   char * argv[] = { NULL, NULL, NULL, NULL, NULL };

   if( hb_pcount() > 0 )
      argv[ 0 ] = ( char * ) hb_parc( 1 );

   if( hb_pcount() > 1 )
      argv[ 1 ] = ( char * ) hb_parc( 2 );

   if( hb_pcount() > 2 )
      argv[ 2 ] = ( char * ) hb_parc( 3 );

   if( hb_pcount() > 3 )
      argv[ 3 ] = ( char * ) hb_parc( 4 );

   g_spawn_async( NULL,
	          argv,
                  NULL,
                  G_SPAWN_SEARCH_PATH /* flags */,
                  NULL /* child_setup */,
		  NULL /* data */,
	          NULL /* child_pid */,
        	  NULL /* error */ );
}

/*

HB_FUNC( WINRUN )
{
   char * argv[] = { NULL, NULL, NULL };

   if( hb_pcount() > 0 )
      argv[ 0 ] = hb_parc( 1 );

   if( hb_pcount() > 1 )
      argv[ 1 ] = hb_parc( 2 );

   g_spawn_sync( NULL,
	         argv,
                 NULL,
                 G_SPAWN_SEARCH_PATH,
                 NULL,
	         NULL,
	         NULL,
        	 NULL );
}

*/
