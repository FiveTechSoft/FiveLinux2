#include <hbapi.h>
#include <gtk/gtk.h>

#ifdef _HARBOUR_
   #define hb_parc hb_parvc
   #define hb_stornl hb_storvnl
#endif

gboolean button_press_event( GtkWidget * hWnd, GdkEventButton * event );
gboolean motion_notify_event( GtkWidget * hWnd, GdkEventMotion * event );

HB_FUNC( CREATEFOLDER )
{
   GtkWidget * hWnd = gtk_notebook_new();

   gtk_signal_connect( GTK_OBJECT( hWnd ), "button_press_event",
                       ( GtkSignalFunc ) button_press_event, NULL );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "motion_notify_event",
                       ( GtkSignalFunc ) motion_notify_event, NULL );

   gtk_widget_set_events( hWnd, GDK_EXPOSURE_MASK
			 | GDK_LEAVE_NOTIFY_MASK
			 | GDK_BUTTON_PRESS_MASK
			 | GDK_POINTER_MOTION_MASK
			 | GDK_POINTER_MOTION_HINT_MASK );

   hb_retnl( ( HB_ULONG ) hWnd );
}

HB_FUNC( FLDSETPROMPTS ) // ( aPrompts ) --> aPagesHandles
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );
   int iPages = hb_parinfa( 2, 0 ), i;

   hb_reta( iPages );

   for( i = 0; i < iPages; i++ )
   {
      GtkWidget * label = gtk_label_new_with_mnemonic( hb_parc( 2, i + 1 ) );
      GtkWidget * fixed;

      gtk_notebook_append_page( GTK_NOTEBOOK( hWnd ),
                                fixed = gtk_fixed_new(), label );
      gtk_widget_show( fixed );

      hb_stornl( ( HB_ULONG ) fixed, -1, i + 1 );
   }
}
