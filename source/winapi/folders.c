#include <hbapi.h>
#include <gtk/gtk.h>

#ifdef _HARBOUR_
   #define hb_parc hb_parvc
   #define hb_stornl hb_storvnl
#endif

HB_FUNC( CREATEFOLDER )
{
   GtkWidget * hWnd = gtk_notebook_new();

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
      hb_stornl( ( HB_ULONG ) fixed, -1, i + 1 );
   }
}
