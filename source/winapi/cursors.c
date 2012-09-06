#include <hbapi.h>
#include <gtk/gtk.h>

HB_FUNC( CREATECURSOR )
{
   GdkCursor * hCursor = gdk_cursor_new( ( GdkCursorType ) hb_parnl( 1 ) );

   gdk_window_set_cursor( ( ( GtkWidget * ) hb_parnl( 1 ) )->window, hCursor );
 
   hb_retnl( ( HB_LONG ) hCursor );
}

HB_FUNC( CURSORSIZE )
{
   GdkCursor * hCursor = gdk_cursor_new( GDK_SIZING );

   gdk_window_set_cursor( ( ( GtkWidget * ) hb_parnl( 1 ) )->window, hCursor );
 
   hb_retnl( ( HB_LONG ) hCursor );
}

HB_FUNC( CURSORARROW )
{
   GdkCursor * hCursor = gdk_cursor_new( GDK_ARROW );

   gdk_window_set_cursor( ( ( GtkWidget * ) hb_parnl( 1 ) )->window, hCursor );
 
   hb_retnl( ( HB_LONG ) hCursor );
}

HB_FUNC( CURSOREND )
{
   gdk_cursor_destroy( ( GdkCursor * ) hb_parnl( 1 ) );
}
