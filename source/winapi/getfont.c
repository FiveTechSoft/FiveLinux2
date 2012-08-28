#include <hbapi.h>
#include <gtk/gtk.h>

void CheckGtkInit( void );

static void ButtonOk( GtkWidget * hWnd, gpointer data )
{
   hb_retc( ( char * ) gtk_font_selection_dialog_get_font_name( GTK_FONT_SELECTION_DIALOG( data ) ) );

   gtk_widget_destroy( ( GtkWidget * ) data );
   gtk_main_quit();
}

static void ButtonCancel( GtkWidget * hWnd, gpointer data )
{
   gtk_widget_destroy( ( GtkWidget * ) data );
   gtk_main_quit();
}

static void DeleteEvent( GtkWidget * hWnd, gpointer data )
{
   gtk_widget_destroy( ( GtkWidget * ) data );
   gtk_main_quit();
}
HB_FUNC( CHOOSEFONT ) // cTitle, cFontName
{
   GtkWidget * hWndParent = NULL;
   GtkWidget * hWnd;

   CheckGtkInit();

   if( gtk_window_list_toplevels() )
      hWndParent = g_list_last( gtk_window_list_toplevels() )->data;

   hWnd = gtk_font_selection_dialog_new( HB_ISCHAR( 1 ) ? hb_parc( 1 ) : "Select a font" );

   /*
   if( hb_pcount() > 1 )
      gtk_font_selection_diaog_set_font_name( GTK_FONT_SELECTION( hWnd ), hb_parc( 2 ) ); */

   g_signal_connect( G_OBJECT( GTK_FONT_SELECTION_DIALOG( hWnd )->ok_button ),
      "clicked", G_CALLBACK( ButtonOk ), hWnd );

   g_signal_connect( G_OBJECT( GTK_FONT_SELECTION_DIALOG( hWnd )->cancel_button ),
      "clicked", G_CALLBACK( ButtonCancel ), hWnd );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "delete_event",
      G_CALLBACK( DeleteEvent ), NULL );

   if( hWndParent )
      gtk_window_set_transient_for( GTK_WINDOW( hWnd ), GTK_WINDOW( hWndParent ) );

   gtk_window_set_modal( GTK_WINDOW( hWnd ), TRUE );

   gtk_widget_show( hWnd );

   gtk_main();
}
