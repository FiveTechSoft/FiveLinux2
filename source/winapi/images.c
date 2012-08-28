#include <hbapi.h>
#include <gtk/gtk.h>

HB_FUNC( CREATEIMAGE )
{
   GtkWidget * hWnd = gtk_image_new();

   hb_retnl( ( HB_ULONG ) hWnd );
}

HB_FUNC( IMGLOADFILE ) // ( cFileName )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   gtk_image_set_from_file( ( GtkImage * ) hWnd, hb_parc( 2 ) );
}

HB_FUNC( IMGGETWIDTH ) // ( hWnd )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   hb_retnl( gdk_pixbuf_get_width( gtk_image_get_pixbuf( ( GtkImage * ) hWnd  ) ) );
}

HB_FUNC( IMGGETHEIGHT ) // ( hWnd )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   hb_retnl( gdk_pixbuf_get_height( gtk_image_get_pixbuf( ( GtkImage * ) hWnd  ) ) );
}
