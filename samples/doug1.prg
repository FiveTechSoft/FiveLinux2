#include "FiveLinux.ch"

#define idProgName "File Match Software"
#define idVersion "0.1.1"
#define idCopName "Finalysis Pty. ltd."
#define idCopDate "2007"
#define idBldDate "25 July 2007"

STATIC oWnd

FUNCTION Main()

// oChecker := CHECKER():Create()

DEFINE WINDOW oWnd TITLE "File Match Software - (c) Finalysis 2007" ;
MENU BldInMenu()

ACTIVATE WINDOW oWnd MAXIMIZED

RETURN

FUNCTION BldInMenu()

LOCAL lomMenu

MENU lomMenu
   MENUITEM "_File"
   MENU
      // MENUITEM "&Match" ACTION oChecker:ShowProDlg()
      MENUITEM "_Exit" ACTION oWnd:End()
   ENDMENU
   MENUITEM "_Help"
   MENU
      MENUITEM "_About" ACTION VerInfo()
   ENDMENU
ENDMENU

RETURN lomMenu

FUNCTION VerInfo()

   LOCAL lodAbout

   DEFINE DIALOG lodAbout TITLE "About Patient Match Software" SIZE 350, 150

   @ 2, 2 SAY ( idProgName + " - Version: " + idVersion ) OF lodAbout SIZE 300, 20

   @ 4, 2 SAY ( "Build Date: " + idBldDate ) OF lodAbout SIZE 300, 20

   @ 6, 2 SAY ( "(c) " + idCopName + " " + idCopDate ) OF lodAbout SIZE 300, 20

   @ 11, 13 BUTTON "OK" ACTION lodAbout:End() OF lodAbout

   ACTIVATE DIALOG lodAbout CENTERED

RETURN nil
