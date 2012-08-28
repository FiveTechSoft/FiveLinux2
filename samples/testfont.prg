#include "FiveLinux.ch"

function Main()

   local oWnd, oFnt1, oFnt2

   DEFINE WINDOW oWnd TITLE "Testing fonts"

   DEFINE FONT oFnt1 NAME "helvetica bold italic 20"

   DEFINE FONT oFnt2 NAME "flubber bold 18"

   @ 5, 5 SAY "Hello world!" OF oWnd SIZE 200, 40 FONT oFnt1

   @ 18, 20 BUTTON "Quit" OF oWnd ACTION oWnd:End() SIZE 100, 30 FONT oFnt2

   ACTIVATE WINDOW oWnd

   RELEASE FONT oFnt1, oFnt2

return nil
