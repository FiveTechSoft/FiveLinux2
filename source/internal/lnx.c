#include <msgs.h>
#include <hbapi.h>
#include <hbvm.h>
#include <gtk/gtk.h>
#include <glade/glade.h>

int MsgInfo( char * szMsg );

PHB_SYMB pFLH = 0;

static GtkWidget * hWndMain = 0;

static HB_BOOL bInit = FALSE;
// static HB_BOOL bRunning = FALSE;

static GladeXML * hResources = 0;

void CheckGtkInit( void )
{
   if( ! bInit )
   {
      gtk_init( NULL, NULL );
      bInit = TRUE;
   }
}

HB_FUNC( __GTKINIT )
{
   CheckGtkInit();

   if( pFLH == 0 )
       pFLH = hb_dynsymSymbol( hb_dynsymFindName( "_FLH" ) );
}

void SetWndMain( GtkWidget * hWnd )
{
   if( ! hWndMain )
      hWndMain = hWnd;
}

HB_FUNC( WINRUN )
{
   // if( ! bRunning )
   // {
   //    bRunning = TRUE;
      gtk_main();
   // }
}

gint ConfigureEvent( GtkWidget * hWnd, GdkEventConfigure * event )
{
   /*	if (!gc) {


                 *  This code is executed on the first configure event only,
                 *  i.e. when the window for the drawing area is created.
                 *  We create a new GC and allocate the colors we will use.

                gc = gdk_gc_new(widget->window);
                init_colors(widget);  } */

   hb_vmPushSymbol( pFLH );
   hb_vmPushNil();
   hb_vmPushLong( WM_SIZE );                    // nMsg
   hb_vmPushLong( ( HB_ULONG ) event->width );     // nWParam
   hb_vmPushLong( ( HB_ULONG ) event->height );    // nLParam
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( hWnd ), "WP" ) );
   hb_vmFunction( 4 );

   // FALSE means = do the default action. TRUE = don't do anything
   return FALSE;  // keep this here or it does not properly resize menu and statusbar
}

gint DeleteEvent( GtkWidget * hWnd, gpointer data )
{
   hb_vmPushSymbol( pFLH );
   hb_vmPushNil();
   hb_vmPushLong( WM_CLOSE );          // nMsg
   hb_vmPushLong( ( HB_ULONG ) data );    // nWParam
   hb_vmPushLong( ( HB_ULONG ) NULL );    // nLParam
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( hWnd ), "WP" ) );
   hb_vmFunction( 4 );

   if( hWnd == hWndMain )
   {
      if( ! HB_ISLOG( -1 ) || hb_parl( -1 ) )
      {
         gtk_main_quit();
	 // hWndMain = 0;
      }
      return TRUE;
   }
   else
   {
      if( ! HB_ISLOG( -1 ) || hb_parl( -1 ) )
         return FALSE;
      else
         return TRUE;
   }
}

HB_FUNC( SYSREFRESH )
{
   while( gtk_events_pending() )
      gtk_main_iteration();
}

int MsgInfo( char * szMsg );

HB_FUNC( SYSQUIT )
{
   // if( ( GtkWidget * ) hb_parnl( 1 ) == hWndMain )
   //    gtk_main_quit();
   // else
   //    gtk_widget_destroy( ( GtkWidget * ) hb_parnl( 1 ) );
      
   if( ( GtkWidget * ) hb_parnl( 1 ) != hWndMain )    
      gtk_widget_destroy( ( GtkWidget * ) hb_parnl( 1 ) );
      
   gtk_main_quit();
}

gint ButtonPressEvent( GtkWidget * hWnd, GdkEventButton * event );

HB_FUNC( SETRESOURCES )
{
   hResources = glade_xml_new( hb_parc( 1 ), NULL, NULL );
}

HB_FUNC( LOADDIALOG )
{
   GtkWidget * hWnd = glade_xml_get_widget( hResources, hb_parc( 1 ) );

   SetWndMain( hWnd );  

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

   hb_retnl( ( glong ) hWnd );
}

gint ClickEvent( GtkWidget * hWnd, GdkEventButton * event );
gint LostFocusEvent( GtkWidget * hWnd, GdkEventFocus * event, gpointer user_data );

HB_FUNC( LOADBUTTON )
{
   GtkWidget * hWnd = glade_xml_get_widget( hResources, hb_parc( 1 ) );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "clicked", ( GtkSignalFunc )
                       ClickEvent, NULL );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "focus-out-event",
		       ( GtkSignalFunc ) LostFocusEvent, NULL );

   hb_retnl( ( glong ) hWnd );
}

gint ClickEvent( GtkWidget * hWnd, GdkEventButton * event )
{
   hb_vmPushSymbol( pFLH );
   hb_vmPushNil();
   hb_vmPushLong( WM_CLICK );          // nMsg
   hb_vmPushLong( ( HB_ULONG ) event );   // nWParam
   hb_vmPushLong( ( HB_ULONG ) NULL );    // nLParam
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( hWnd ), "WP" ) );
   hb_vmFunction( 4 );

   return TRUE;
}

void MenuItemSelect( GtkMenuItem * hMenuItem, gpointer user_data )
{
   hb_vmPushSymbol( pFLH );
   hb_vmPushNil();
   hb_vmPushLong( WM_MENUCMD );           // nMsg
   hb_vmPushLong( ( HB_ULONG ) hMenuItem );  // nWParam
   hb_vmPushLong( 0 );                    // nLParam
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( hMenuItem ),
   						 "WP" ) );
   hb_vmFunction( 4 );
}

gint LostFocusEvent( GtkWidget * hWnd, GdkEventFocus * event, gpointer user_data )
{
   GtkWidget * hScrolls = gtk_object_get_data( GTK_OBJECT( hWnd ), "hScrolls" );

   if( hScrolls != NULL )
      hWnd = hScrolls;

   hb_vmPushSymbol( pFLH );
   hb_vmPushNil();
   hb_vmPushLong( WM_LOSTFOCUS );      // nMsg
   hb_vmPushLong( ( HB_ULONG ) event );   // nWParam
   hb_vmPushLong( ( HB_ULONG ) NULL );    // nLParam
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( hWnd ), "WP" ) );
   hb_vmFunction( 4 );

   return FALSE;
}

gint GotFocusEvent( GtkWidget * hWnd, GdkEventFocus * event, gpointer user_data )
{
   GtkWidget * hScrolls = gtk_object_get_data( GTK_OBJECT( hWnd ), "hScrolls" );

   if( hScrolls != NULL )
      hWnd = hScrolls;

   hb_vmPushSymbol( pFLH );
   hb_vmPushNil();
   hb_vmPushLong( WM_GOTFOCUS );      // nMsg
   hb_vmPushLong( ( HB_ULONG ) event );   // nWParam
   hb_vmPushLong( ( HB_ULONG ) NULL );    // nLParam
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( hWnd ), "WP" ) );
   hb_vmFunction( 4 );

   return FALSE;
}

void LbxChangeEvent( GtkList * hWnd, GtkWidget * hItem, gpointer user_data )

{
   hb_vmPushSymbol( pFLH );
   hb_vmPushNil();
   hb_vmPushLong( WM_CHANGE );         // nMsg
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( hItem ), "index" ) );    // nWParam
   hb_vmPushLong( ( HB_ULONG ) NULL );    // nLParam
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( user_data ), "WP" ) );
   hb_vmFunction( 4 );
}

void CbxChangeEvent( GtkList * hWnd, GtkWidget * hItem, gpointer user_data )

{
   hb_vmPushSymbol( pFLH );
   hb_vmPushNil();
   hb_vmPushLong( WM_CHANGE );         // nMsg
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( hItem ), "index" ) );    // nWParam
   hb_vmPushLong( ( HB_ULONG ) NULL );    // nLParam
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( user_data ), "WP" ) );
   hb_vmFunction( 4 );
}

gboolean PaintEvent( GtkWidget * hWnd, GdkEventExpose * event )
{
   hb_vmPushSymbol( pFLH );
   hb_vmPushNil();
   hb_vmPushLong( WM_PAINT );          // nMsg
   hb_vmPushLong( ( HB_ULONG ) event );   // nWParam
   hb_vmPushLong( ( HB_ULONG ) NULL );    // nLParam
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( hWnd ), "WP" ) );
   hb_vmFunction( 4 );

   return FALSE;
}

gboolean KeyPressEvent( GtkWidget * hWnd, GdkEventKey * event )
{
   hb_vmPushSymbol( pFLH );
   hb_vmPushNil();
   hb_vmPushLong( WM_KEYDOWN );        // nMsg
   hb_vmPushLong( ( HB_ULONG ) event->keyval );   // nWParam
   hb_vmPushLong( ( HB_ULONG ) NULL );    // nLParam
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( hWnd ), "WP" ) );
   hb_vmFunction( 4 );

   if( event->keyval == 65289 || ( event->keyval == 65289 && ( event->state & GDK_SHIFT_MASK ) ) ) // K_TAB
      return FALSE;
   else
      return TRUE;
}

gboolean ButtonPressEvent( GtkWidget * hWnd, GdkEventButton * event )
{
   hb_vmPushSymbol( pFLH );
   hb_vmPushNil();

   if( event->button == 1 )
   {
      if( event->type == GDK_2BUTTON_PRESS )
         hb_vmPushLong( WM_LDBLCLICK );
      else   			
         hb_vmPushLong( WM_LBUTTONDOWN );    // nMsg
   }      
   else // 3
   {
      if( event->type == GDK_2BUTTON_PRESS )
         hb_vmPushLong( WM_RDBLCLICK );
      else   
         hb_vmPushLong( WM_RBUTTONDOWN );    // nMsg
   }      

   hb_vmPushLong( ( HB_ULONG ) event->y );   // nWParam
   hb_vmPushLong( ( HB_ULONG ) event->x );   // nLParam
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( hWnd ), "WP" ) );
   hb_vmFunction( 4 );

   return FALSE;
}

gboolean button_press_event( GtkWidget * hWnd, GdkEventButton * event ) 
{
   if( event->button == 1 ) 
   {   
      hb_vmPushSymbol( pFLH );
      hb_vmPushNil();
      hb_vmPushLong( WM_LBUTTONDOWN );        // nMsg
      hb_vmPushLong( ( HB_ULONG ) event->y ); // nWParam
      hb_vmPushLong( ( HB_ULONG ) event->x ); // nLParam
      hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( hWnd ), "WP" ) );
      hb_vmFunction( 4 );
   }
   
   return TRUE;
}

gboolean motion_notify_event( GtkWidget * hWnd, GdkEventMotion * event ) 
{
   int x, y;
   GdkModifierType state;

   gdk_window_get_pointer( hWnd->window, &x, &y, &state );

   hb_vmPushSymbol( pFLH );
   hb_vmPushNil();
   hb_vmPushLong( WM_MOUSEMOVE );    // nMsg
   hb_vmPushLong( ( HB_ULONG ) y );  // nWParam
   hb_vmPushLong( ( HB_ULONG ) x );  // nLParam
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( hWnd ), "WP" ) );
   hb_vmFunction( 4 );

   return TRUE;
}

void RadioButtonClick( GtkToggleButton * hWnd, gpointer data )
{
   hb_vmPushSymbol( pFLH );
   hb_vmPushNil();
   hb_vmPushLong( WM_CLICK );          // nMsg
   hb_vmPushLong( ( HB_ULONG ) NULL );    // nWParam
   hb_vmPushLong( ( HB_ULONG ) NULL );    // nLParam
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( hWnd ), "WP" ) );
   hb_vmFunction( 4 );
}

void ScrollBarChanged( GtkAdjustment * adjustment, gpointer user_data )
{
   hb_vmPushSymbol( pFLH );
   hb_vmPushNil();
   hb_vmPushLong( WM_SCROLL );            // nMsg
   hb_vmPushLong( ( HB_ULONG ) NULL );       // nWParam
   hb_vmPushLong( ( HB_ULONG ) NULL );       // nLParam
   hb_vmPushLong( ( HB_ULONG ) gtk_object_get_data( GTK_OBJECT( user_data ), "WP" ) );
   hb_vmFunction( 4 );
}

static glong timer = 0;

static gboolean TimerEvent( gpointer data )
{
   static PHB_SYMB symTimerEvent = NULL;

   if( symTimerEvent == NULL )
      symTimerEvent = hb_dynsymSymbol( hb_dynsymFindName( "TIMEREVENT" ) );

   hb_vmPushSymbol( symTimerEvent );
   hb_vmPushNil();
   hb_vmPushLong( timer );
   hb_vmFunction( 1 );
   return TRUE;
}

HB_FUNC( SETTIMER )
{
   timer = ( glong ) g_timeout_add( hb_parnl( 1 ), TimerEvent, NULL );
   hb_retnl( timer );
}

HB_FUNC( KILLTIMER )
{
   hb_retl( g_source_remove( ( guint ) hb_parnl( 1 ) ) );
}
