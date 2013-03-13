#include <hbapi.h>
#include <hbvm.h>
#include <gtk/gtk.h>

gint LostFocusEvent( GtkWidget * hWnd, GdkEventFocus * event,
                     gpointer user_data );

HB_FUNC( CREATETEXT )
{
   GtkWidget * hViewPort = gtk_viewport_new( NULL, NULL );
   GtkWidget * hScrollBars = gtk_scrolled_window_new( NULL, NULL );
   GtkWidget * hWnd = gtk_text_view_new();

   gtk_text_view_set_cursor_visible( GTK_TEXT_VIEW( hWnd ), TRUE );

   gtk_container_add( GTK_CONTAINER( hScrollBars ), hWnd ); // ViewPort );
   // gtk_container_add( GTK_CONTAINER( hViewPort ), hWnd );

   gtk_object_set_data( GTK_OBJECT( hScrollBars ), "hWnd", ( gpointer ) hWnd );
   gtk_object_set_data( GTK_OBJECT( hWnd ), "hScrolls",
                        ( gpointer ) hScrollBars );
   gtk_object_set_data( GTK_OBJECT( hScrollBars ), "hViewPort", ( gpointer ) hViewPort );

   GTK_WIDGET_SET_FLAGS( hScrollBars, GTK_CAN_FOCUS );
   gtk_scrolled_window_set_policy( GTK_SCROLLED_WINDOW( hScrollBars ),
                                   GTK_POLICY_NEVER, GTK_POLICY_ALWAYS );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "focus_out_event",
                       GTK_SIGNAL_FUNC( LostFocusEvent ), NULL );

   hb_retnl( ( HB_ULONG ) hScrollBars );
}

HB_FUNC( TXTSETTEXT )
{
   GtkWidget * hWnd = gtk_object_get_data( GTK_OBJECT( hb_parnl( 1 ) ), "hWnd" );
   GtkTextBuffer * buffer = gtk_text_view_get_buffer( GTK_TEXT_VIEW( hWnd ) );

   gtk_text_buffer_set_text( buffer, hb_parc( 2 ), -1 );
}

HB_FUNC( TXTGETTEXT )
{
   GtkWidget * hWnd = gtk_object_get_data( GTK_OBJECT( hb_parnl( 1 ) ), "hWnd" );
   GtkTextBuffer * buffer = gtk_text_view_get_buffer( GTK_TEXT_VIEW( hWnd ) );
   GtkTextIter start, end;

   gtk_text_buffer_get_bounds( buffer, &start, &end );

   hb_retc( gtk_text_buffer_get_text( buffer, &start, &end, TRUE ) );
}
