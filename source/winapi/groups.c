#include <hbapi.h>
#include <gtk/gtk.h>

HB_FUNC( CREATEGROUP )
{
   GtkWidget * hWnd = gtk_frame_new( hb_parc( 1 ) );

   hb_retnl( ( HB_ULONG ) hWnd );
}

HB_FUNC( GRPSETTEXT )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   gtk_frame_set_label( ( GtkFrame * ) hWnd, hb_parc( 2 ) );
}

HB_FUNC( GRPGETTEXT )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   hb_retc( ( char * ) gtk_frame_get_label( ( GtkFrame * ) hWnd ) );
}
