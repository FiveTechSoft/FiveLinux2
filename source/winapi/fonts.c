#include <hbapi.h>
#include <gtk/gtk.h>

HB_FUNC( CREATEFONT )
{
   PangoFontDescription * hFont =
      pango_font_description_from_string( hb_parc( 1 ) );

   hb_retnl( ( HB_ULONG ) hFont );
}

HB_FUNC( DESTROYFONT )
{
   pango_font_description_free( ( PangoFontDescription * ) hb_parnl( 1 ) );
}
