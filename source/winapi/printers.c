#include <hbapi.h>
#include <gtk/gtk.h>
#include <libgnomeprint/gnome-print.h>
#include <libgnomeprint/gnome-print-job.h>
#include <libgnomeprintui/gnome-print-dialog.h>

void CheckGtkInit( void );

static HB_BOOL bInit = FALSE;

HB_FUNC( CREATEPRINTER )
{
   if( ! bInit )
   {
      bInit = TRUE;
      g_type_init();
   }

   hb_retnl( ( HB_ULONG ) gnome_print_job_new( NULL ) );
}

HB_FUNC( PRNGETGPC )
{
   hb_retnl( ( HB_ULONG ) gnome_print_job_get_context( ( GnomePrintJob * )
             hb_parnl( 1 ) ) );
}

HB_FUNC( PRNSTARTPAGE )
{
   gnome_print_beginpage( ( GnomePrintContext * ) hb_parnl( 1 ),
                          ( const guchar * ) hb_parc( 2 ) );
}

HB_FUNC( PRNENDPAGE )
{
   gnome_print_showpage( ( GnomePrintContext * ) hb_parnl( 1 ) );
}

HB_FUNC( PRNMOVETO )
{
   gnome_print_moveto( ( GnomePrintContext * ) hb_parnl( 1 ),
                       hb_parnl( 2 ), hb_parnl( 3 ) );
}

HB_FUNC( PRNSAY )
{
   gnome_print_show( ( GnomePrintContext * ) hb_parnl( 1 ), ( const guchar * ) hb_parc( 2 ) );
}

HB_FUNC( PRNLINE )
{
   gnome_print_lineto( ( GnomePrintContext * ) hb_parnl( 1 ), hb_parnl( 3 ),
                       hb_parnl( 2 ) );
   gnome_print_stroke( ( GnomePrintContext * ) hb_parnl( 1 ) );
}

HB_FUNC( PRNEND )
{
   GnomePrintJob * job = ( GnomePrintJob * ) hb_parnl( 1 );

   gnome_print_job_close( job );
   gnome_print_job_print( job );

   g_object_unref( G_OBJECT( hb_parnl( 2 ) ) );
   g_object_unref( G_OBJECT( job ) );
}

HB_FUNC( PRNDIALOG )
{
   GtkWidget * dialog;
   gint response;

   CheckGtkInit();

   dialog = gnome_print_dialog_new( ( GnomePrintJob * ) hb_parnl( 1 ),
                                    ( const guchar * ) hb_parc( 2 ), 0 );
   gtk_window_set_position( GTK_WINDOW( dialog ), GTK_WIN_POS_CENTER );				    
   gtk_widget_show( dialog );
   response = gtk_dialog_run( GTK_DIALOG( dialog ) );

   hb_retl( response != GNOME_PRINT_DIALOG_RESPONSE_CANCEL );
}

HB_FUNC( PRNGETWIDTH )
{
   GnomePrintConfig * config = gnome_print_job_get_config(
                               ( GnomePrintJob * ) hb_parnl( 1 ) );
   gdouble width;

   gnome_print_config_get_length( config, ( guchar * ) GNOME_PRINT_KEY_PAPER_WIDTH,
				  &width, NULL);
   hb_retnl( width );
}

HB_FUNC( PRNGETHEIGHT )
{
   GnomePrintConfig * config = gnome_print_job_get_config(
                               ( GnomePrintJob * ) hb_parnl( 1 ) );
   gdouble height;

   gnome_print_config_get_length( config, ( guchar * ) GNOME_PRINT_KEY_PAPER_HEIGHT,
				  &height, NULL);
   hb_retnl( height );
}
