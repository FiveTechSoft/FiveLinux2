#include <hbapi.h>
#include <gtk/gtk.h>

HB_FUNC( CREATEMSGBAR )
{
   GtkWidget * hWnd = gtk_statusbar_new();
   GtkWidget * hVBox = ( GtkWidget * ) gtk_object_get_data( GTK_OBJECT(
                       hb_parnl( 1 ) ), "vbox" );

   gtk_box_pack_start( GTK_BOX( hVBox ), hWnd, FALSE, FALSE, 0 );

   hb_retnl( ( HB_ULONG ) hWnd );
}

HB_FUNC( SETMSGBARTEXT )
{
   gtk_statusbar_push( ( GtkStatusbar * ) hb_parnl( 1 ), hb_parnl( 2 ),
                       ( char * ) hb_parc( 3 ) );
}
