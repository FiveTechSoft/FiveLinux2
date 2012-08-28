#include <hbapi.h>
#include <gtk/gtk.h>

void CheckGtkInit( void );

static void ButtonOk( GtkWidget * hWnd, gpointer data )
{
   GtkColorSelection * colorsel = GTK_COLOR_SELECTION(
                                 GTK_COLOR_SELECTION_DIALOG( data )->colorsel );
   GdkColor color;

   gtk_color_selection_get_current_color( colorsel, &color );
   hb_retnd( color.pixel );

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

HB_FUNC( CHOOSECOLOR ) // cTitle, nColor
{
   GtkWidget * hWndParent = NULL;
   GtkWidget * hWnd;

   CheckGtkInit();

   if( gtk_window_list_toplevels() )
      hWndParent = g_list_last( gtk_window_list_toplevels() )->data;

   hWnd = gtk_color_selection_dialog_new( HB_ISCHAR( 1 ) ? hb_parc( 1 ) : "Select a color" );

   if( HB_ISNUM( 2 ) )
   {
      gdouble color = hb_parnd( 2 );

      gtk_color_selection_set_color(
         GTK_COLOR_SELECTION( GTK_COLOR_SELECTION_DIALOG( hWnd )->colorsel ),
	                      &color );
   }

   g_signal_connect( G_OBJECT( GTK_COLOR_SELECTION_DIALOG( hWnd )->ok_button ),
      "clicked", G_CALLBACK( ButtonOk ), hWnd );

   g_signal_connect( G_OBJECT( GTK_COLOR_SELECTION_DIALOG( hWnd )->cancel_button ), "clicked", G_CALLBACK( ButtonCancel ), hWnd );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "delete_event",
      G_CALLBACK( DeleteEvent ), NULL );

   if( hWndParent )
      gtk_window_set_transient_for( GTK_WINDOW( hWnd ), GTK_WINDOW( hWndParent ) );

   gtk_window_set_modal( GTK_WINDOW( hWnd ), TRUE );

   gtk_widget_show( hWnd );

   gtk_main();
}
