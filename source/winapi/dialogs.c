#include <hbapi.h>
#include <gtk/gtk.h>

void SetWndMain( GtkWidget * hWnd );
gint DeleteEvent( GtkWidget * hWnd, gpointer data );
gint ButtonPressEvent( GtkWidget * hWnd, GdkEventButton * event );

static GtkWidget * hWndParent = NULL;

HB_FUNC( CREATEDIALOG )
{
   GtkWidget * hWnd  = gtk_window_new( GTK_WINDOW_TOPLEVEL );
   GtkWidget * hVBox = gtk_vbox_new( FALSE, 0 );
   GtkWidget * hFixed = gtk_fixed_new();

   SetWndMain( hWnd );

   gtk_container_add( GTK_CONTAINER ( hWnd ), hVBox );
   gtk_box_pack_start( GTK_BOX( hVBox ), hFixed, TRUE, TRUE, 0 );

   gtk_object_set_data( GTK_OBJECT( hWnd ), "vbox", ( gpointer ) hVBox );
   gtk_object_set_data( GTK_OBJECT( hWnd ), "fixed", ( gpointer ) hFixed );

   gtk_window_set_default_size( GTK_WINDOW( hWnd ), 100, 100 );
   
   gtk_signal_connect( GTK_OBJECT( hWnd ), "delete_event",
      GTK_SIGNAL_FUNC( ( GtkSignalFunc ) DeleteEvent ), NULL );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "button_press_event",
                       ( GtkSignalFunc ) ButtonPressEvent, NULL );

   gtk_widget_set_events( hWnd, GDK_CONFIGURE |
                                GDK_EXPOSURE_MASK |
                                GDK_LEAVE_NOTIFY_MASK |
                                GDK_BUTTON_PRESS_MASK |
                                GDK_POINTER_MOTION_MASK |
                                GDK_POINTER_MOTION_HINT_MASK );

   hb_retnl( ( HB_ULONG ) hWnd );
}

HB_FUNC( SETMODAL )
{
   if( hb_pcount() == 2 )
      hWndParent = ( GtkWidget * ) hb_parnl( 2 );

   if( hWndParent )
      gtk_window_set_transient_for( ( GtkWindow * ) hb_parnl( 1 ),
                                    ( GtkWindow * ) hWndParent );

   gtk_window_set_modal( GTK_WINDOW( hb_parnl( 1 ) ), TRUE );
}
