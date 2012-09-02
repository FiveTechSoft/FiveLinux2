#include <hbapi.h>
#include <gtk/gtk.h>

gboolean button_press_event( GtkWidget * hWnd, GdkEventButton * event );
gboolean motion_notify_event( GtkWidget * hWnd, GdkEventMotion * event );

HB_FUNC( CREATESAY )
{
   GtkWidget * hWnd = gtk_label_new( hb_parc( 1 ) );
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

HB_FUNC( SAYSETTEXT )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );
   GList * children = gtk_container_get_children( ( GtkContainer * ) hWnd );

   gtk_label_set_text( children->data, hb_parc( 2 ) );
}

HB_FUNC( SAYGETTEXT )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );
   GList * children = gtk_container_get_children( ( GtkContainer * ) hWnd );

   hb_retc( ( char * ) gtk_label_get_text( children->data ) );
}

HB_FUNC( SAYSETJUSTIFY )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   gtk_label_set_justify( ( GtkLabel * ) hWnd, ( GtkJustification ) hb_parnl( 2 ) );
}
