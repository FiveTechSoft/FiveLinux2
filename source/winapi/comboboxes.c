#include <hbapi.h>
#include <gtk/gtk.h>

#ifdef _HARBOUR_
   #define hb_parc hb_parvc
#endif

gint LostFocusEvent( GtkWidget * hWnd, GdkEventFocus * event,
                     gpointer user_data );
void CbxChangeEvent( GtkList * hWnd, GtkWidget * hItem, gpointer user_data );
gboolean button_press_event( GtkWidget * hWnd, GdkEventButton * event );
gboolean motion_notify_event( GtkWidget * hWnd, GdkEventMotion * event );

HB_FUNC( CREATECOMBOBOX )
{
   GtkWidget * hWnd = gtk_combo_new();

   GTK_WIDGET_SET_FLAGS( hWnd, GTK_CAN_FOCUS );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "focus_out_event",
                       GTK_SIGNAL_FUNC( LostFocusEvent ), NULL );

   gtk_signal_connect( GTK_OBJECT( GTK_COMBO( hWnd )->list ), "select-child",
                       GTK_SIGNAL_FUNC( CbxChangeEvent ), ( gpointer ) hWnd );

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

HB_FUNC( CBXSETTEXT ) // ( hWnd, cText )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   gtk_entry_set_text( GTK_ENTRY( GTK_COMBO( hWnd )->entry ), hb_parc( 2 ) );
}

HB_FUNC( CBXGETTEXT ) // ( hWnd ) --> cText
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   hb_retc( ( char * ) gtk_entry_get_text( GTK_ENTRY( GTK_COMBO( hWnd )->entry ) ) );
}

HB_FUNC( CBXSETITEMS ) // ( hWnd, aItems )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );
   int iLen = hb_parinfa( 2, 0 ), i;
   GList * glist = NULL;

   for( i = 0; i < iLen; i++ )
      glist = g_list_append( glist, ( char * ) hb_parc( 2, i + 1 ) );

   gtk_combo_set_popdown_strings( GTK_COMBO( hWnd ), glist );

   if( glist != NULL )
      g_list_free( glist );
}
