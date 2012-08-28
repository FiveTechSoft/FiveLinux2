#include <hbapi.h>
#include <gtk/gtk.h>

void ScrollBarChanged( GtkAdjustment * adjustment, gpointer user_data );

HB_FUNC( CREATESCROLL ) // lVertical
{
   GtkWidget * hWnd;

   if( hb_parl( 1 ) )
      hWnd = gtk_vscrollbar_new( NULL );
   else
      hWnd = gtk_hscrollbar_new( NULL );

   gtk_range_set_update_policy( GTK_RANGE( hWnd ), GTK_UPDATE_DISCONTINUOUS );

   hb_retnl( ( HB_ULONG ) hWnd );
}

HB_FUNC( SCRLSETRANGE )
{
   GtkObject * adj = gtk_adjustment_new( 1, hb_parnl( 2 ), hb_parnl( 3 ), 1, hb_parnl( 4 ), 
                                         hb_parnl( 4 ) ); // same value for page down and up

   gtk_range_set_adjustment( GTK_RANGE( hb_parnl( 1 ) ),
                             GTK_ADJUSTMENT( adj ) );

   g_signal_connect( adj, "value-changed", G_CALLBACK( ScrollBarChanged ),
                     ( gpointer ) hb_parnl( 1 ) );
}

HB_FUNC( SCRLGETRANGE )
{
   GtkAdjustment * adjust = gtk_range_get_adjustment( GTK_RANGE( hb_parnl( 1 ) ) );

   hb_reta( 2 );
   hb_storvnl( adjust->lower, -1, 1 );
   hb_storvnl( adjust->upper, -1, 2 ); 
}

HB_FUNC( SCRLSETVALUE )
{
   GtkAdjustment * adj = gtk_range_get_adjustment( GTK_RANGE( hb_parnl( 1 ) ) );

   gtk_adjustment_set_value( adj, hb_parnl( 2 ) );
}

HB_FUNC( SCRLGETVALUE )
{
   GtkAdjustment * adj = gtk_range_get_adjustment( GTK_RANGE( hb_parnl( 1 ) ) );

   hb_retnl( gtk_adjustment_get_value( adj ) );
}
