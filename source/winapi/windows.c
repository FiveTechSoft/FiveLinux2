#include <hbapi.h>
#include <gtk/gtk.h>

int MsgInfo( char * szMsg );
gint ButtonPressEvent( GtkWidget * hWnd, GdkEventButton * event );
gint DeleteEvent( GtkWidget * hWnd, gpointer Data );
gint ConfigureEvent( GtkWidget * hWnd, GdkEventConfigure * event );
gboolean motion_notify_event( GtkWidget * hWnd, GdkEventMotion * event );
void SetWndMain( GtkWidget * hWnd );

HB_FUNC( CREATEWINDOW )
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
                       ( GtkSignalFunc ) DeleteEvent, NULL );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "button_press_event",
                       ( GtkSignalFunc ) ButtonPressEvent, NULL );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "configure_event",
                       ( GtkSignalFunc ) ConfigureEvent, NULL );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "motion_notify_event",
                       ( GtkSignalFunc ) motion_notify_event, NULL );

   gtk_widget_set_events( hWnd, GDK_CONFIGURE |
                                GDK_EXPOSURE_MASK |
                                GDK_LEAVE_NOTIFY_MASK |
                                GDK_BUTTON_PRESS_MASK |
                                GDK_POINTER_MOTION_MASK |
                                GDK_POINTER_MOTION_HINT_MASK );

   hb_retnl( ( HB_ULONG ) hWnd );
}

HB_FUNC( WNDDESTROY )
{
   gtk_widget_destroy( ( GtkWidget * ) hb_parnl( 1 ) );
}

HB_FUNC( SETPARENT )
{
   gpointer fixed = gtk_object_get_data( GTK_OBJECT( hb_parnl( 2 ) ), "fixed" );

   if( fixed == NULL )
      fixed = ( gpointer ) hb_parnl( 2 );

   gtk_container_add( GTK_CONTAINER( fixed ), ( GtkWidget * ) hb_parnl( 1 ) );
}

HB_FUNC( SETPOPUPPARENT )
{
   gtk_container_add( GTK_CONTAINER( hb_parnl( 2 ) ),
    		      ( GtkWidget * ) hb_parnl( 1 ) );
}

HB_FUNC( SETCOORS )
{
   gtk_widget_set_uposition( ( GtkWidget * ) hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 2 ) );
}

HB_FUNC( SETFOCUS )
{
   gtk_widget_grab_focus( ( ( GtkWidget * ) hb_parnl( 1 ) ) );
}

HB_FUNC( GETFOCUS )
{
   GtkWidget * hWnd = NULL;
   
   if( gtk_window_list_toplevels() )
      hWnd = g_list_last( gtk_window_list_toplevels() )->data;

   hb_retnl( ( HB_ULONG ) gtk_window_get_focus( GTK_WINDOW( hWnd ) ) );
}

HB_FUNC( SETPROP )
{
   gtk_object_set_data( GTK_OBJECT( hb_parnl( 1 ) ), hb_parc( 2 ), ( gpointer ) hb_parnl( 3 ) );
}

HB_FUNC( GETPROP )
{
   hb_retnl( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( hb_parnl( 1 ) ), hb_parc( 2 ) ) );
}

HB_FUNC( GETLEFT )
{
   hb_retnl( ( ( GtkWidget * ) hb_parnl( 1 ) )->allocation.x );
}

HB_FUNC( GETTOP )
{
   hb_retnl( ( ( GtkWidget * ) hb_parnl( 1 ) )->allocation.y );
}

HB_FUNC( GETWIDTH )
{
   hb_retnl( ( ( GtkWidget * ) hb_parnl( 1 ) )->allocation.width );
}

HB_FUNC( GETHEIGHT )
{
   hb_retnl( ( ( GtkWidget * ) hb_parnl( 1 ) )->allocation.height );
}

HB_FUNC( CTRLSETSIZE )
{
   GtkWidget * hViewPort = gtk_object_get_data( ( GtkObject * ) hb_parnl( 1 ), "hViewPort" );
   GtkWidget * hWnd = gtk_object_get_data( ( GtkObject * ) hb_parnl( 1 ), "hWnd" );

   if( hViewPort )
      gtk_widget_set_usize( hViewPort, hb_parnl( 2 ), hb_parnl( 3 ) );

   // if( hWnd )
   //    gtk_widget_set_usize( hWnd, hb_parnl( 2 ), hb_parnl( 3 ) );

   gtk_widget_set_usize( ( GtkWidget * ) hb_parnl( 1 ), hb_parnl( 2 ), hb_parnl( 3 ) );
}

HB_FUNC( CTRLSETPOS )
{
   gtk_widget_set_uposition( ( GtkWidget * ) hb_parnl( 1 ), hb_parnl( 3 ), hb_parnl( 2 ) );
}

HB_FUNC( WNDSETSIZE )
{
   gtk_window_set_default_size( ( GtkWindow * ) hb_parnl( 1 ), hb_parnl( 2 ), hb_parnl( 3 ) );
}

HB_FUNC( WNDSETPOS )
{
   gtk_window_move( GTK_WINDOW( hb_parnl( 1 ) ), hb_parnl( 3 ), hb_parnl( 2 ) );
}

HB_FUNC( WNDGETPOS )
{
   gint x, y;

   gtk_window_get_position( GTK_WINDOW( hb_parnl( 1 ) ), &x, &y );
   
   hb_reta( 2 );
   hb_storvnl( x, -1, 1 );
   hb_storvnl( y, -1, 2 );
}

HB_FUNC( WNDSETTEXT )
{
   gtk_window_set_title( GTK_WINDOW( hb_parnl( 1 ) ), hb_parc( 2 ) );
}

HB_FUNC( WNDGETTEXT )
{
   hb_retc( gtk_window_get_title( GTK_WINDOW( hb_parnl( 1 ) ) ) );
}

HB_FUNC( SHOWWINDOW )
{
   gtk_widget_show_all( ( GtkWidget * ) hb_parnl( 1 ) );
}

HB_FUNC( SHOWCONTROL )
{
   gtk_widget_show( ( GtkWidget * ) hb_parnl( 1 ) );
}

HB_FUNC( WNDENABLE )
{
   gtk_widget_set_sensitive( ( GtkWidget * ) hb_parnl( 1 ), hb_parl( 2 ) );
}

HB_FUNC( WNDHIDE )
{
   gtk_widget_hide( ( GtkWidget * ) hb_parnl( 1 ) );
}

HB_FUNC( WNDMAXIMIZE )
{
   gtk_window_maximize( ( GtkWindow * ) hb_parnl( 1 ) );
}

HB_FUNC( WNDREFRESH )
{
   GtkWidget * hWnd  = ( GtkWidget * ) hb_parnl( 1 );
   GdkRectangle rect = { 0, 0,
                         hWnd->allocation.width, hWnd->allocation.height };

   gdk_window_invalidate_rect( hWnd->window, &rect, TRUE );
}

HB_FUNC( WNDCENTER )
{
   gtk_window_set_position( GTK_WINDOW( hb_parnl( 1 ) ), GTK_WIN_POS_CENTER );
}

HB_FUNC( WNDSETTOOLTIP )
{
   GtkWidget * hWnd  = ( GtkWidget * ) hb_parnl( 1 );
   GtkTooltips * tooltips = gtk_tooltips_new();

   gtk_tooltips_set_tip( tooltips, hWnd, hb_parc( 2 ), NULL );
}

HB_FUNC( BRINGWINDOWTOTOP )
{
   GtkWidget * hWnd  = ( GtkWidget * ) hb_parnl( 1 );

   gtk_window_set_keep_above( GTK_WINDOW( hWnd ), hb_parl( 2 ) );
}

HB_FUNC( SETFONT )
{
   GtkWidget * hWnd  = ( GtkWidget * ) hb_parnl( 1 );

   gtk_widget_modify_font( hWnd, ( PangoFontDescription * ) hb_parnl( 2 ) );
}
