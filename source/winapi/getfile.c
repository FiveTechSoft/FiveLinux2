#include <hbapi.h>
#include <gtk/gtk.h>

void CheckGtkInit( void );

static void ButtonOk( GtkWidget * hWnd, gpointer data )
{
   hb_retc( ( char * ) gtk_file_selection_get_filename( GTK_FILE_SELECTION( data ) ) );

   gtk_widget_destroy( ( GtkWidget * ) data );
   gtk_main_quit();
}

static void ButtonCancel( GtkWidget * hWnd, gpointer data )
{
   gtk_widget_destroy( ( GtkWidget * ) data );
   gtk_main_quit();
}

static gint DeleteEvent( GtkWidget * hWnd, gpointer data )
{
   gtk_main_quit();

   return FALSE;
}

HB_FUNC( CGETFILE ) // cTitle, cFileName
{
   GtkWidget * hWndParent = NULL;
   GtkWidget * hWnd;

   CheckGtkInit();

   if( gtk_window_list_toplevels() )
      hWndParent = g_list_last( gtk_window_list_toplevels() )->data;

   hWnd = gtk_file_selection_new( HB_ISCHAR( 2 ) ? hb_parc( 2 ) : "Select a file" );

   gtk_file_selection_set_filename( GTK_FILE_SELECTION( hWnd ), hb_parc( 1 ) );

   g_signal_connect( G_OBJECT( GTK_FILE_SELECTION( hWnd )->ok_button ),
      "clicked", G_CALLBACK( ButtonOk ), hWnd );

   g_signal_connect( G_OBJECT( GTK_FILE_SELECTION( hWnd )->cancel_button ),
      "clicked", G_CALLBACK( ButtonCancel ), hWnd );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "delete_event",
      G_CALLBACK( DeleteEvent ), NULL );

   if( hWndParent )
      gtk_window_set_transient_for( GTK_WINDOW( hWnd ), GTK_WINDOW( hWndParent ) );

   gtk_window_set_modal( GTK_WINDOW( hWnd ), TRUE );

   gtk_widget_show( hWnd );

   gtk_main();
}
