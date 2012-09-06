#include <hbapi.h>
#include <gtk/gtk.h>

HB_FUNC( ISLBTNPRESSED )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 ); 
   int x, y;
   GdkModifierType state;
   
   gdk_window_get_pointer( hWnd->window, &x, &y, &state );
	
   hb_retl( state & GDK_BUTTON1_MASK );
}

HB_FUNC( MOUSEGETROW )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 ); 
   int x, y;
   GdkModifierType state;
   
   gdk_window_get_pointer( hWnd->window, &x, &y, &state );
	
   hb_retnl( y );
}

HB_FUNC( MOUSEGETCOL )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 ); 
   int x, y;
   GdkModifierType state;
   
   gdk_window_get_pointer( hWnd->window, &x, &y, &state );
	
   hb_retnl( x );
}
