// Ejemplo de implementacion de la clase Folder
// (c) Rafa Carmona

#include "FiveLinux.ch"

#define CRLF Hb_OsNewLine()

Function Main()
         Local oWnd, oFld, oBtn
	 Local lShow := .F., lBorder := .F., lScroll := .F., lPopup := .F.

	 DEFINE WINDOW oWnd TITLE "Test de Folders."

	 @1,1 FOLDER oFld PROMPTS "TOP","BOTTOM","LEFT","RIGHT",;
	           "RIBA","PABAJO","IZQUIERA","DERECHITO" OF oWnd

	 @2,30 BUTTON oBtn PROMPT "Arriba" ACTION oFld:SetPosition( 0 ) OF oWnd
         @6,30 BUTTON oBtn PROMPT "Abajo" ACTION oFld:SetPosition( 1 ) OF oWnd
         @10,30 BUTTON oBtn PROMPT "Izquierda" ACTION oFld:SetPosition( 2 ) OF oWnd
	 @14,30 BUTTON oBtn PROMPT "Derecha" ACTION oFld:SetPosition( 3 ) OF oWnd

	 @18,30 BUTTON oBtn PROMPT "Scroll" ;
	        ACTION oFld:SetScroll( lScroll := !lScroll ) OF oWnd

	 @22,30 BUTTON oBtn PROMPT "<" ACTION oFld:Prev() OF oWnd SIZE 40,25
         @22,34 BUTTON oBtn PROMPT ">" ACTION oFld:Next() OF oWnd SIZE 40,25

	 @22,1 BUTTON oBtn PROMPT "Hide/Show Tabs" ;
	      ACTION ( oFld:ShowTabs( lShow ), lShow := !lShow ) ;
	      OF oWnd SIZE 120,30

	 @26,1 BUTTON oBtn PROMPT "Hide/Show Border" ;
	      ACTION ( oFld:ShowBorder( lBorder ), lBorder := !lBorder ) ;
	      SIZE 120,30 OF oWnd

	 @22,15 BUTTON oBtn PROMPT "Tab Actual" ;
	      ACTION MsgInfo(  oFld:GetPage()  ) ;
	      SIZE 120,30 OF oWnd

	 @26,15 BUTTON oBtn PROMPT "Popup en Tabs" ;
	      ACTION ( oFld:SetPopup( lPopup := ! lPopup ),;
	               MsgInfo( "Si presiona boton del Mouse derecho"+CRLF+;
		                "encima de los tabs, lo tienes en forma popup!!"  ) ) ;
	      SIZE 120,30 OF oWnd

	 oWnd:Center()  // Centrado la ventana

	 ACTIVATE WINDOW oWnd

RETURN NIL
