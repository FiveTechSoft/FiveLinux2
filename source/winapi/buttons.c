#include <hbapi.h>
#include <gtk/gtk.h>

gint ClickEvent( GtkWidget * hWnd, GdkEventButton * event );
gint LostFocusEvent( GtkWidget * hWnd, GdkEventButton * event, gpointer data );
gboolean button_press_event( GtkWidget * hWnd, GdkEventButton * event );
gboolean motion_notify_event( GtkWidget * hWnd, GdkEventMotion * event );

HB_FUNC( CREATEBUTTON )
{
   GtkWidget * hWnd;

   if( HB_ISCHAR( 2 ) )
      hWnd = gtk_button_new_from_stock( hb_parc( 2 ) );
   else
      hWnd = gtk_button_new_with_mnemonic( hb_parc( 1 ) );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "clicked", ( GtkSignalFunc )
                       ClickEvent, NULL );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "focus-out-event",
		       ( GtkSignalFunc ) LostFocusEvent, NULL );

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

void MsgInfo( char * msg );

HB_FUNC( CREATEBTN )
{
   GtkWidget * hToolBar = ( GtkWidget * ) gtk_object_get_data( GTK_OBJECT(
                          hb_parnl( 1 ) ), "hToolBar" );
   GtkWidget * hWnd;

   if( hb_parl( 4 ) )
      gtk_toolbar_append_space( GTK_TOOLBAR( hToolBar ) );

   if( HB_ISCHAR( 5 ) )
   {
      GtkWidget * image = gtk_image_new_from_file( hb_parc( 5 ) );

      hWnd = gtk_toolbar_append_item( GTK_TOOLBAR( hToolBar), NULL,
                                      hb_parc( 2 ), "Private", 
                                      image, NULL, NULL );
   }
   else if( HB_ISCHAR( 3 ) )
   {
      hWnd = gtk_toolbar_insert_stock( GTK_TOOLBAR( hToolBar ),
                                       hb_parc( 3 ),
                                       hb_parc( 2 ), NULL, NULL, NULL, -1 );
   }
   else
   {
      hWnd = gtk_toolbar_append_element( GTK_TOOLBAR( hToolBar ),
                                         GTK_TOOLBAR_CHILD_BUTTON,
                                         NULL, NULL, hb_parc( 2 ), NULL,
                                         NULL, NULL, NULL );

      gtk_label_set_use_underline( GTK_LABEL( ( ( GtkToolbarChild * )
      ( g_list_last( GTK_TOOLBAR( hToolBar )->children )->data ) )->label ),
      TRUE );
   }

   gtk_signal_connect( GTK_OBJECT( hWnd ), "clicked", ( GtkSignalFunc )
                       ClickEvent, NULL );

   hb_retnl( ( HB_ULONG ) hWnd );
}

HB_FUNC( BTNSETTEXT )
{
   gtk_button_set_label( GTK_BUTTON( hb_parnl( 1 ) ), hb_parc( 2 ) );
}

HB_FUNC( BTNGETTEXT )
{
   hb_retc( ( char * ) gtk_button_get_label( GTK_BUTTON( hb_parnl( 1 ) ) ) );
}
