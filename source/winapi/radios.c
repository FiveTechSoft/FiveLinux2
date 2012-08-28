#include <hbapi.h>
#include <gtk/gtk.h>

void RadioButtonClick( GtkToggleButton * hWnd, gpointer data );

HB_FUNC( CREATERADIO )
{
   GSList * radios_group = ( GSList * ) hb_parnl( 2 );
   GtkWidget * hWnd = gtk_radio_button_new_with_label( radios_group, "" );
   guint radio_key = gtk_label_parse_uline( GTK_LABEL( GTK_BIN( hWnd )->
                                            child), hb_parc( 1 ) );
   GtkAccelGroup * accel_group = gtk_accel_group_new();

   gtk_widget_add_accelerator( hWnd, "clicked", accel_group, radio_key,
                               GDK_MOD1_MASK, ( GtkAccelFlags ) 0 );
   radios_group = gtk_radio_button_group( GTK_RADIO_BUTTON( hWnd ) );

   hb_stornl( ( HB_ULONG ) radios_group, 2 );

  gtk_signal_connect( GTK_OBJECT( hWnd ), "toggled",
                      GTK_SIGNAL_FUNC( RadioButtonClick ), NULL );

   hb_retnl( ( HB_ULONG ) hWnd );
}

HB_FUNC( RADCHECKED )
{
   hb_retl( gtk_toggle_button_get_active( GTK_TOGGLE_BUTTON( hb_parnl( 1 ) ) ) );
}

HB_FUNC( RADSETCHECK )
{
   gtk_toggle_button_set_active( GTK_TOGGLE_BUTTON( hb_parnl( 1 ) ), hb_parl( 2 ) );
}
