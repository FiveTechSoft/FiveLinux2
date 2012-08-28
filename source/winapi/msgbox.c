#include <hbapi.h>
#include <hbapiitm.h>
#include <gtk/gtk.h>

void CheckGtkInit( void );

int MsgAlert( char * szMsg )
{
   GtkWidget * hWnd, * hWndParent = NULL;
   int iResult;

   CheckGtkInit();

   if( gtk_window_list_toplevels() )
      hWndParent = g_list_last( gtk_window_list_toplevels() )->data;

   hWnd = gtk_message_dialog_new( GTK_WINDOW( hWndParent ),
                                  GTK_DIALOG_MODAL,
                                  GTK_MESSAGE_WARNING, GTK_BUTTONS_OK, "%s", szMsg );

   gtk_window_set_policy( GTK_WINDOW( hWnd ), FALSE, FALSE, FALSE );
   gtk_window_set_position( GTK_WINDOW( hWnd ), GTK_WIN_POS_CENTER );

   iResult = gtk_dialog_run( GTK_DIALOG( hWnd ) );
   gtk_widget_destroy( hWnd );

   return iResult;
}

int MsgInfo( char * szMsg )
{
   GtkWidget * hWnd, * hWndParent = NULL;
   int iResult;

   CheckGtkInit();

   if( gtk_window_list_toplevels() )
      hWndParent = g_list_last( gtk_window_list_toplevels() )->data;

   hWnd = gtk_message_dialog_new( GTK_WINDOW( hWndParent ),
                                  GTK_DIALOG_MODAL,
                                  GTK_MESSAGE_INFO, GTK_BUTTONS_OK, "%s", szMsg );

   gtk_window_set_transient_for( GTK_WINDOW( hWnd ), GTK_WINDOW( hWndParent ) );

   gtk_window_set_policy( GTK_WINDOW( hWnd ), FALSE, FALSE, FALSE );
   gtk_window_set_position( GTK_WINDOW( hWnd ), GTK_WIN_POS_CENTER );
   gtk_window_set_keep_above( GTK_WINDOW( hWnd ), TRUE );

   iResult = gtk_dialog_run( GTK_DIALOG( hWnd ) );
   gtk_widget_destroy( hWnd );

   return iResult;
}

int MsgStop( char * szMsg )
{
   GtkWidget * hWnd, * hWndParent = NULL;
   int iResult;

   CheckGtkInit();

   if( gtk_window_list_toplevels() )
      hWndParent = g_list_last( gtk_window_list_toplevels() )->data;

   hWnd = gtk_message_dialog_new( GTK_WINDOW( hWndParent ),
                                  GTK_DIALOG_MODAL,
                                  GTK_MESSAGE_ERROR, GTK_BUTTONS_OK, "%s", szMsg );

   gtk_window_set_policy( GTK_WINDOW( hWnd ), FALSE, FALSE, FALSE );
   gtk_window_set_position( GTK_WINDOW( hWnd ), GTK_WIN_POS_CENTER );

   iResult = gtk_dialog_run( GTK_DIALOG( hWnd ) );
   gtk_widget_destroy( hWnd );

   return iResult;
}

int MsgYesNo( char * szMsg )
{
   GtkWidget * hWnd, * hWndParent = NULL;
   int iResult;

   CheckGtkInit();

   if( gtk_window_list_toplevels() )
      hWndParent = g_list_last( gtk_window_list_toplevels() )->data;

   hWnd = gtk_message_dialog_new( GTK_WINDOW( hWndParent ),
                                  GTK_DIALOG_MODAL,
                                  GTK_MESSAGE_QUESTION,
                                  GTK_BUTTONS_YES_NO, "%s", szMsg );

   gtk_window_set_policy( GTK_WINDOW( hWnd ), FALSE, FALSE, FALSE );
   gtk_window_set_position( GTK_WINDOW( hWnd ), GTK_WIN_POS_CENTER );

   iResult = gtk_dialog_run( GTK_DIALOG( hWnd ) );
   gtk_widget_destroy( hWnd );

   return iResult;
}

HB_FUNC( MSGALERT )
{
   HB_ULONG ulLen;
   HB_BOOL bFreeReq;
   char * buffer;

   if( hb_pcount() )
      hb_retnl( MsgAlert( buffer = ( char * ) hb_itemString( hb_param( 1, HB_IT_ANY ),
                &ulLen, &bFreeReq ) ) );
   else
      hb_retnl( MsgInfo( "NIL" ) );

   if( hb_pcount() && bFreeReq )
      hb_xfree( ( void * ) buffer );
}

HB_FUNC( MSGINFO )
{
   HB_ULONG ulLen;
   HB_BOOL bFreeReq;
   char * buffer;

   if( hb_pcount() )
      hb_retnl( MsgInfo( buffer = ( char * ) hb_itemString( hb_param( 1, HB_IT_ANY ),
                &ulLen, &bFreeReq ) ) );
   else
      hb_retnl( MsgInfo( "NIL" ) );

   if( hb_pcount() && bFreeReq )
      hb_xfree( ( void * ) buffer );
}

HB_FUNC( MSGSTOP )
{
   HB_ULONG ulLen;
   HB_BOOL bFreeReq;
   char * buffer;

   if( hb_pcount() )
      hb_retnl( MsgStop( buffer = ( char * ) hb_itemString( hb_param( 1, HB_IT_ANY ),
                &ulLen, &bFreeReq ) ) );
   else
      hb_retnl( MsgStop( "NIL" ) );

   if( hb_pcount() && bFreeReq )
      hb_xfree( ( void * ) buffer );
}

HB_FUNC( MSGYESNO )
{
   HB_ULONG ulLen;
   HB_BOOL bFreeReq;
   char * buffer;

   if( hb_pcount() )
      hb_retl( MsgYesNo( buffer = ( char * ) hb_itemString( hb_param( 1, HB_IT_ANY ),
                &ulLen, &bFreeReq ) ) == -8 );
   else
      hb_retl( MsgYesNo( "NIL" ) == -8 );

   if( hb_pcount() && bFreeReq )
      hb_xfree( ( void * ) buffer );
}

HB_FUNC( MSGBEEP )
{
   gdk_beep();
}
