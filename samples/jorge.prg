#include "FiveLinux.ch"

function Main()

   local oWnd, oBtn, oFont, oSay

   DEFINE WINDOW oWnd SIZE 1200, 800

   DEFINE FONT oFont NAME "Helvetica Bold 100"

   @ 39, 9 SAY oSay PROMPT "Caja" OF oWnd FONT oFont

   @ 60, 44 BUTTON oBtn PROMPT "Continuar" OF oWnd

   ACTIVATE WINDOW oWnd 

return nil 
