#include <hbapi.h>
#include <gtk/gtk.h>

gint ClickEvent( GtkWidget * hWnd, GdkEventButton * event );

gint LostFocusEvent( GtkWidget * hWnd, GdkEventFocus * event,
                     gpointer user_data );
gboolean button_press_event( GtkWidget * hWnd, GdkEventButton * event );
gboolean motion_notify_event( GtkWidget * hWnd, GdkEventMotion * event );

HB_FUNC( CREATECHECKBOX )
{
   GtkWidget * hWnd = gtk_check_button_new_with_label( hb_parc( 1 ) );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "clicked", ( GtkSignalFunc ) ClickEvent, NULL );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "focus_out_event",
                       GTK_SIGNAL_FUNC( LostFocusEvent ), NULL );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "button_press_event",
                       ( GtkSignalFunc ) button_press_event, NULL );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "motion_notify_event",
                       ( GtkSignalFunc ) motion_notify_event, NULL );

   gtk_widget_set_events( hWnd, GDK_EXPOSURE_MASK
			 | GDK_LEAVE_NOTIFY_MASK
			 | GDK_BUTTON_PRESS_MASK
			 | GDK_POINTER_MOTION_MASK
			 | GDK_POINTER_MOTION_HINT_MASK );

   hb_retnl( ( HB_ULONG ) hWnd );
}

HB_FUNC( CBXSETCHECK )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   gtk_toggle_button_set_active( GTK_TOGGLE_BUTTON( hWnd ), hb_parl( 2 ) ); }

HB_FUNC( CBXGETCHECK )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   hb_retl( gtk_toggle_button_get_active( GTK_TOGGLE_BUTTON( hWnd ) ) );
}
