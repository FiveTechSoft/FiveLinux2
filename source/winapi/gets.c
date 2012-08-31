#include <hbapi.h>
#include <hbvm.h>
#include <gtk/gtk.h>

gboolean LostFocusEvent( GtkWidget * hWnd, GdkEventFocus * event,
                         gpointer user_data );
gboolean GotFocusEvent( GtkWidget * hWnd, GdkEventFocus * event,
                        gpointer user_data );
gboolean KeyPressEvent( GtkWidget * hWnd, GdkEventKey * event,
                        gpointer user_data );
gboolean ButtonPressEvent( GtkWidget * hWnd, GdkEventButton * event );

HB_FUNC( CREATEGET )
{
   GtkWidget * hWnd = gtk_entry_new();

   gtk_signal_connect( GTK_OBJECT( hWnd ), "focus_out_event",
                       G_CALLBACK( LostFocusEvent ), NULL );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "focus_in_event",
                       G_CALLBACK( GotFocusEvent ), NULL );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "key_press_event",
                       G_CALLBACK( KeyPressEvent ), NULL );

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

HB_FUNC( GETGETCURPOS )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   hb_retni( gtk_editable_get_position( GTK_EDITABLE( hWnd ) ) );
}

HB_FUNC( GETSETCURPOS )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   gtk_editable_set_position( GTK_EDITABLE( hWnd ), hb_parni( 2 ) );
}

HB_FUNC( GETSETTEXT )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   gtk_entry_set_text( GTK_ENTRY( hWnd ), hb_parc( 2 ) );
}

HB_FUNC( GETGETTEXT )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   hb_retc( ( char * ) gtk_entry_get_text( GTK_ENTRY( hWnd ) ) );
}

HB_FUNC( GETSETSEL )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   gtk_entry_select_region( GTK_ENTRY( hWnd ), hb_parni( 2 ), hb_parni( 3 ) );
}

