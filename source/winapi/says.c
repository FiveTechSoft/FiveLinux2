#include <hbapi.h>
#include <gtk/gtk.h>

HB_FUNC( CREATESAY )
{
   GtkWidget * hWnd = gtk_label_new( hb_parc( 1 ) );

   hb_retnl( ( HB_ULONG ) hWnd );
}

HB_FUNC( SAYSETTEXT )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   gtk_label_set_text( ( GtkLabel * ) hWnd, hb_parc( 2 ) );
}

HB_FUNC( SAYGETTEXT )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   hb_retc( ( char * ) gtk_label_get_text( ( GtkLabel * ) hWnd ) );
}


HB_FUNC( SAYSETJUSTIFY )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   gtk_label_set_justify( ( GtkLabel * ) hWnd, ( GtkJustification ) hb_parnl( 2 ) );
}
