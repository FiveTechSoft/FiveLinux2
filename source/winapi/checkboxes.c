#include <hbapi.h>
#include <gtk/gtk.h>

gint ClickEvent( GtkWidget * hWnd, GdkEventButton * event );

gint LostFocusEvent( GtkWidget * hWnd, GdkEventFocus * event,
                     gpointer user_data );

HB_FUNC( CREATECHECKBOX )
{
   GtkWidget * hWnd = gtk_check_button_new_with_label( hb_parc( 1 ) );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "clicked", ( GtkSignalFunc ) ClickEvent, NULL );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "focus_out_event",
                       GTK_SIGNAL_FUNC( LostFocusEvent ), NULL );

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
