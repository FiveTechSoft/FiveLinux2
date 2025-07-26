#include "FiveLinux.ch"

function Main()

   local oWnd, oBtn, oFont, oSay

   DEFINE WINDOW oWnd SIZE 1200, 800

   // ChooseFont()

   DEFINE FONT oFont NAME "Sans Bold 24"

   @ 29, 9 SAY oSay PROMPT "Caja" OF oWnd FONT oFont

   @ 35, 44 BUTTON oBtn PROMPT "Continuar" OF oWnd

   ACTIVATE WINDOW oWnd 

return nil 
