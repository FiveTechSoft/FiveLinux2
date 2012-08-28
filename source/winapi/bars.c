#include <hbapi.h>
#include <gtk/gtk.h>

HB_FUNC( CREATEBAR )
{
   GtkWidget * hWnd = gtk_handle_box_new();
   GtkWidget * hVBox = ( GtkWidget * ) gtk_object_get_data( GTK_OBJECT(
                       hb_parnl( 1 ) ), "vbox" );
   GtkWidget * hToolBar = gtk_toolbar_new();

   gtk_object_set_data( GTK_OBJECT( hWnd ), "hToolBar",
                        ( gpointer ) hToolBar );

   gtk_box_pack_start( GTK_BOX( hVBox ), hWnd, FALSE, TRUE, 0 );
   gtk_box_reorder_child( GTK_BOX( hVBox ), hWnd, 1 );

   gtk_widget_set_size_request( hWnd, 0, hb_parnl( 3 ) );

   gtk_container_add( GTK_CONTAINER( hWnd ), hToolBar );
   gtk_toolbar_set_style( GTK_TOOLBAR( hToolBar ), GTK_TOOLBAR_BOTH );

   hb_retnl( ( HB_ULONG ) hWnd );
}
