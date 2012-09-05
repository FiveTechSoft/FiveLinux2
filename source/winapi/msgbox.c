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

int MsgYesNo( char * szMsg , char * cTitle )
{
   GtkWidget * hWnd, * hWndParent = NULL;
   int iResult;
    
    CheckGtkInit();

   if( gtk_window_list_toplevels() )
      hWndParent = g_list_last( gtk_window_list_toplevels() )->data;

   hWnd = gtk_message_dialog_new( GTK_WINDOW( hWndParent ),
                                  GTK_DIALOG_MODAL,
                                  GTK_MESSAGE_QUESTION,
                                  GTK_BUTTONS_NONE, "%s", szMsg );

 gtk_dialog_add_button( GTK_DIALOG( hWnd  ), GTK_STOCK_NO, 0 );
 gtk_dialog_add_button( GTK_DIALOG( hWnd  ), GTK_STOCK_YES, 1 );

   gtk_window_set_title( GTK_WINDOW( hWnd ), cTitle );


   gtk_window_set_policy( GTK_WINDOW( hWnd ), FALSE, FALSE, FALSE );
   gtk_window_set_position( GTK_WINDOW( hWnd ), GTK_WIN_POS_CENTER );

   gtk_dialog_set_default_response( GTK_DIALOG(  hWnd ), 1  ) ;
  

   iResult =  gtk_dialog_run( GTK_DIALOG( hWnd ) ) ;
   gtk_widget_destroy( hWnd );

   return iResult;
}

int MsgNoYes( char * szMsg , char * cTitle )
{
   GtkWidget * hWnd, * hWndParent = NULL;
   int iResult;
    
    CheckGtkInit();

   if( gtk_window_list_toplevels() )
      hWndParent = g_list_last( gtk_window_list_toplevels() )->data;

   hWnd = gtk_message_dialog_new( GTK_WINDOW( hWndParent ),
                                  GTK_DIALOG_MODAL,
                                  GTK_MESSAGE_QUESTION,
                                  GTK_BUTTONS_NONE, "%s", szMsg );

 gtk_dialog_add_button( GTK_DIALOG( hWnd  ), GTK_STOCK_YES, 1 );
 gtk_dialog_add_button( GTK_DIALOG( hWnd  ), GTK_STOCK_NO, 0 );
 

   gtk_window_set_title( GTK_WINDOW( hWnd ), cTitle );


   gtk_window_set_policy( GTK_WINDOW( hWnd ), FALSE, FALSE, FALSE );
   gtk_window_set_position( GTK_WINDOW( hWnd ), GTK_WIN_POS_CENTER );

   gtk_dialog_set_default_response( GTK_DIALOG(  hWnd ), 0  ) ;
  

   iResult =  gtk_dialog_run( GTK_DIALOG( hWnd ) ) ;
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

  // if( hb_pcount() && bFreeReq )
  //    hb_xfree( ( void * ) buffer );
}


HB_FUNC( MSGYESNO )
{
   HB_ULONG ulLen;
   HB_BOOL bFreeReq;
   HB_BOOL bFreeReqT;

   char * buffer;
   char * ctitle ;

  //  ctitle= "Atención" ;
  
   if( hb_pcount() )
       {
      if( hb_pcount() > 1 )
     {	   
       ctitle = hb_itemString( hb_param( 2, HB_IT_ANY ), &ulLen, &bFreeReqT ) ;
             }
       else
        ctitle = "Attention";	 
  
        buffer = ( char * ) hb_itemString( hb_param( 1, HB_IT_ANY ), &ulLen, &bFreeReq ) ;
	hb_retl( MsgYesNo( buffer,ctitle ) == 1 );
       }
   else
      hb_retl( MsgYesNo( "NIL","NIL" ) == 1 );

   if( hb_pcount() && bFreeReq )
     {
      hb_xfree( ( void * ) buffer );
     if ( bFreeReqT )
      hb_xfree( ( void * ) ctitle );     
     }
}


HB_FUNC( MSGNOYES )
{
   HB_ULONG ulLen;
   HB_BOOL bFreeReq;
   HB_BOOL bFreeReqT;

   char * buffer;
   char * ctitle ;

  //  ctitle= "Atención" ;
  
   if( hb_pcount() )
       {
      if( hb_pcount() > 1 )
     {	   
       ctitle = hb_itemString( hb_param( 2, HB_IT_ANY ), &ulLen, &bFreeReqT ) ;
             }
       else
        ctitle = "Attention";	 
  
        buffer = ( char * ) hb_itemString( hb_param( 1, HB_IT_ANY ), &ulLen, &bFreeReq ) ;
	hb_retl( MsgNoYes( buffer,ctitle ) == 1 );
       }
   else
      hb_retl( MsgNoYes( "NIL","NIL" ) == 1 );

   if( hb_pcount() && bFreeReq )
     {
      hb_xfree( ( void * ) buffer );
     if ( bFreeReqT )
      hb_xfree( ( void * ) ctitle );     
     }
}

HB_FUNC( MSGBEEP )
{
   gdk_beep();
}
