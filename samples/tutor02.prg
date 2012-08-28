#include "FiveLinux.ch"

function Main()

   local oWnd
   
   DEFINE WINDOW oWnd TITLE "Welcome to FiveLinux"

   ACTIVATE WINDOW oWnd CENTERED ;
      ON RIGHT CLICK MsgInfo( "Right click" ) ; 
      VALID MsgYesNo( "Do you want to exit ?" ) 

return nil
