#include <hbapi.h>
#include <sys/types.h>
#include <sys/stat.h>

HB_FUNC( SETEXECUTABLE )
{
   chmod( hb_parc( 1 ), 0744 );
}
