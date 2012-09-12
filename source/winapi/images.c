#include <hbapi.h>
#include <gtk/gtk.h>

gboolean button_press_event( GtkWidget * hWnd, GdkEventButton * event );
gboolean motion_notify_event( GtkWidget * hWnd, GdkEventMotion * event );

HB_FUNC( CREATEIMAGE )
{
   GtkWidget * hWnd = gtk_image_new();
   GtkWidget * event_box = gtk_event_box_new();

   gtk_signal_connect( GTK_OBJECT( event_box ), "button_press_event",
                       ( GtkSignalFunc ) button_press_event, NULL );

   gtk_signal_connect( GTK_OBJECT( event_box ), "motion_notify_event",
                       ( GtkSignalFunc ) motion_notify_event, NULL );

   gtk_widget_set_events( event_box, GDK_EXPOSURE_MASK
			 | GDK_LEAVE_NOTIFY_MASK
			 | GDK_BUTTON_PRESS_MASK
			 | GDK_POINTER_MOTION_MASK
			 | GDK_POINTER_MOTION_HINT_MASK );

   gtk_container_add( GTK_CONTAINER( event_box ), hWnd );
   gtk_widget_show( hWnd );

   hb_retnl( ( HB_ULONG ) event_box );
}

HB_FUNC( IMGLOADFILE ) // ( cFileName )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );
   GList * children = gtk_container_get_children( ( GtkContainer * ) hWnd );

   gtk_image_set_from_file( children->data, hb_parc( 2 ) );
}

HB_FUNC( IMGGETWIDTH ) // ( hWnd )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );
   GList * children = gtk_container_get_children( ( GtkContainer * ) hWnd );

   hb_retnl( gdk_pixbuf_get_width( gtk_image_get_pixbuf( children->data  ) ) );
}

HB_FUNC( IMGGETHEIGHT ) // ( hWnd )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );
   GList * children = gtk_container_get_children( ( GtkContainer * ) hWnd );

   hb_retnl( gdk_pixbuf_get_height( gtk_image_get_pixbuf( children->data  ) ) );
}
