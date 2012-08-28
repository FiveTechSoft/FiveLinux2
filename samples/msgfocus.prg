#include "FiveLinux.ch"

Function Main()

   local oWnd_Primera, oBtn

   DEFINE WINDOW oWnd_Primera TITLE hb_strtoutf8('pantalla 1') SIZE 1024, 690

 

   @60,30 BUTTON oBtn PROMPT "Continuar" OF oWnd_Primera SIZE 120, 20 ACTION ( prueba2( oWnd_Primera ) )

   ACTIVATE WINDOW oWnd_Primera

Return .T.

 

Function prueba2( oWnd )

   local oWnd_Segunda, oBtn

   DEFINE WINDOW oWnd_Segunda TITLE hb_strtoutf8('pantalla 2') SIZE 500, 400

   // SetParent( oWnd_Segunda:hWnd, oWnd:hWnd )

 

   @20,20 BUTTON oBtn PROMPT "Mensaje" OF oWnd_Segunda SIZE 120, 20 ACTION MsgInfo( "test" )

   ACTIVATE WINDOW oWnd_Segunda

Return .T.
