#include "FiveLinux.ch"

static nCalled := 0, lExit := .F.

function Main()

  if Fork() != 0
     return nil 
  endif   
   
  Signal() 
  Alarm( 1 )
  
  Printf( "Main loop starts" + HB_OSNewLine() )
  
  while ! lExit
     Sleep( 30 )
  end   

  Printf( "Main loop ends" + HB_OSNewLine() )

return nil

function CatchAlarm( cMsg )
 
   Printf( Time() + HB_OSNewLine() )
   
   if ++nCalled > 9
      lExit := .T.
   else   
      Alarm( 1 ) // Require a next timer event
   endif   
   
return nil   

#pragma BEGINDUMP

#include <signal.h>
#include <hbapi.h>
#include <hbvm.h>

HB_FUNC( FORK )
{
   hb_retnl( fork() );
}   

void CatchAlarm( int sig )
{
   hb_vmPushSymbol( hb_dynsymGetSymbol( "CATCHALARM" ) );
   hb_vmPushNil();
   hb_vmPushString( "PRG level from C", strlen( "PRG level from C" ) );
   hb_vmFunction( 1 );
}

HB_FUNC( SIGNAL )
{
   signal( SIGALRM, CatchAlarm );
}   

HB_FUNC( ALARM )
{
   alarm( hb_parnl( 1 ) );
}   

HB_FUNC( PRINTF )
{
   printf( hb_parc( 1 ) );
}

HB_FUNC( SLEEP )
{
   sleep( hb_parnl( 1 ) );
}      
   
#pragma ENDDUMP