#include <msgs.h>
#include <hbapi.h>
#include <hbvm.h>
#include <gtk/gtk.h>

HB_FUNC( CREATEPROGRESS )
{
   GtkWidget * hWnd = gtk_progress_bar_new();

   hb_retnl( ( HB_ULONG ) hWnd );
}

HB_FUNC( PROSET )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   gtk_progress_bar_set_fraction( ( GtkProgressBar * ) hWnd, ( gdouble ) hb_parnd( 2 ) );
}

HB_FUNC( PROSETTEXT )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   gtk_progress_bar_set_text( ( GtkProgressBar * ) hWnd, hb_parc( 2 ) );
}
