#include <hbapi.h>
#include <hbvm.h>
#include <gtk/gtk.h>

#ifdef _HARBOUR_
   #define hb_parc hb_parvc
   #define hb_stornl hb_storvnl
#endif

void LbxChangeEvent( GtkList * hWnd, GtkWidget * hItem, gpointer user_data );

gint LostFocusEvent( GtkWidget * hWnd, GdkEventFocus * event,
                     gpointer user_data );

gboolean button_press_event( GtkWidget * hWnd, GdkEventButton * event );
gboolean motion_notify_event( GtkWidget * hWnd, GdkEventMotion * event );

HB_FUNC( CREATELISTBOX )
{
   GtkWidget * hViewPort = gtk_viewport_new( NULL, NULL );
   GtkWidget * hScrollBars = gtk_scrolled_window_new( NULL, NULL );
   GtkWidget * hWnd = gtk_list_new();

   gtk_container_add( GTK_CONTAINER( hScrollBars ), hViewPort );
   gtk_container_add( GTK_CONTAINER( hViewPort ), hWnd );

   gtk_object_set_data( GTK_OBJECT( hScrollBars ), "hWnd", ( gpointer ) hWnd );

   GTK_WIDGET_SET_FLAGS( hScrollBars, GTK_CAN_FOCUS );
   gtk_scrolled_window_set_policy( GTK_SCROLLED_WINDOW( hScrollBars ),
                                   GTK_POLICY_NEVER, GTK_POLICY_ALWAYS );

   // gtk_signal_connect( GTK_OBJECT( hWnd ), "focus_out_event",
   //                    GTK_SIGNAL_FUNC( LostFocusEvent ), NULL );

   gtk_list_set_selection_mode( GTK_LIST( hWnd ), GTK_SELECTION_BROWSE );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "select-child",
                       GTK_SIGNAL_FUNC( LbxChangeEvent ), ( gpointer ) hScrollBars );

   gtk_signal_connect( GTK_OBJECT( hScrollBars ), "button_press_event",
                       ( GtkSignalFunc ) button_press_event, NULL );

   gtk_signal_connect( GTK_OBJECT( hScrollBars ), "motion_notify_event",
                       ( GtkSignalFunc ) motion_notify_event, NULL );

   gtk_widget_set_events( hWnd, GDK_EXPOSURE_MASK
			 | GDK_LEAVE_NOTIFY_MASK
			 | GDK_BUTTON_PRESS_MASK
			 | GDK_POINTER_MOTION_MASK
			 | GDK_POINTER_MOTION_HINT_MASK );

   gtk_widget_show( hViewPort );
   gtk_widget_show( hWnd );

   hb_retnl( ( HB_ULONG ) hScrollBars );
}

HB_FUNC( LBXSETITEMS ) // ( hWnd, aItems )
{
   GtkWidget * hWnd = gtk_object_get_data( GTK_OBJECT( hb_parnl( 1 ) ), "hWnd" );
   int iLen = hb_parinfa( 2, 0 ), i;

   for( i = 0; i < iLen; i++ )
   {
      GtkWidget * listItem = gtk_list_item_new_with_label( hb_parc( 2, i + 1 ) );
      gtk_object_set_data( GTK_OBJECT( listItem ), "index", ( gpointer ) ( i + 1 ) );
      gtk_container_add( GTK_CONTAINER( hWnd ), listItem );
   }
}

HB_FUNC( LBXSELITEM ) // ( hWnd, nItem )
{
   GtkWidget * hWnd = gtk_object_get_data( GTK_OBJECT( hb_parnl( 1 ) ), "hWnd" );

   gtk_list_select_item( GTK_LIST( hWnd ), hb_parni( 2 ) - 1 );
}
