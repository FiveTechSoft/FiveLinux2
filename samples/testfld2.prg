// Ejemplo de implementacion de la clase Folder
// (c) Rafa Carmona

#include "FiveLinux.ch"

Function Main()
         Local oWnd, oFld, oBtn
	 Local lShow := .F., lBorder := .F.

	 DEFINE WINDOW oWnd TITLE "Test de Folders."

	 @1,1 FOLDER oFld PROMPTS "TOP","BOTTOM","LEFT","RIGHT" OF oWnd

         @2,40 BUTTON oBtn PROMPT "<" ACTION oFld:Prev() OF oWnd SIZE 40,25
         @2,44 BUTTON oBtn PROMPT ">" ACTION oFld:Next() OF oWnd SIZE 40,25

	 @2,30 BUTTON oBtn PROMPT "Arriba" ACTION oFld:SetPosition( 0 ) OF oWnd
         @6,30 BUTTON oBtn PROMPT "Abajo" ACTION oFld:SetPosition( 1 ) OF oWnd
         @10,30 BUTTON oBtn PROMPT "Izquierda" ACTION oFld:SetPosition( 2 ) OF oWnd
         @14,30 BUTTON oBtn PROMPT "Derecha" ACTION oFld:SetPosition( 3 ) OF oWnd

	 @22,1 BUTTON oBtn PROMPT "Hide/Show Tabs" ;
	      ACTION ( oFld:ShowTabs( lShow ), lShow := !lShow ) ;
	      OF oWnd SIZE 120,30

	 @26,1 BUTTON oBtn PROMPT "Hide/Show Border" ;
	      ACTION ( oFld:ShowBorder( lBorder ), lBorder := !lBorder ) ;
	      SIZE 120,30 OF oWnd

	 @22,15 BUTTON oBtn PROMPT "Tab Actual" ;
	      ACTION MsgInfo(  oFld:GetPage()  ) ;
	      SIZE 120,30 OF oWnd


	 oWnd:Center()  // Centrado la ventana

	 ACTIVATE WINDOW oWnd

RETURN NIL
