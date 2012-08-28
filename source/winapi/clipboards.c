#include <hbapi.h>
#include <gtk/gtk.h>

HB_FUNC( CREATECLIPBOARD )
{
   GtkClipboard * hClipboard = gtk_clipboard_get( GDK_SELECTION_CLIPBOARD );

   hb_retnl( ( ULONG ) hClipboard );
}

HB_FUNC( CLPSETTEXT )
{
   GtkClipboard * hClipboard = ( GtkClipboard * ) hb_parnl( 1 );

   gtk_clipboard_set_text( hClipboard, hb_parc( 2 ), -1 );
}

HB_FUNC( CLPGETTEXT )
{
   GtkClipboard * hClipboard = ( GtkClipboard * ) hb_parnl( 1 );

   hb_retc( ( char * ) gtk_clipboard_wait_for_text( hClipboard ) );
}

HB_FUNC( CLPCLEAR )
{
   GtkClipboard * hClipboard = ( GtkClipboard * ) hb_parnl( 1 );

   gtk_clipboard_clear( hClipboard );
   gtk_clipboard_set_text( hClipboard, "", -1 );
}
