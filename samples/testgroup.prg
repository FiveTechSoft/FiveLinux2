// Ejemplo de implementacion de la clase Group
// (c) Rafa Carmona

#include "FiveLinux.ch"

Function Main()
         Local oWnd, oGroup1,oGroup2,oGroup3,oGroup4

	 DEFINE WINDOW oWnd TITLE "Test de Groups."

         @1,1  GROUP oGroup1 LABEL "Default" SIZE 100,100 OF oWnd

	 @1,11 GROUP oGroup2 LABEL "0-NONE" SIZE 50,50 OF oWnd
         oGroup2:Shadow( 0 )

	 @1,18 GROUP oGroup3 LABEL "1-IN" SIZE 100,100 OF oWnd
         oGroup3:Shadow( 1 )

	 @1,29 GROUP oGroup3 LABEL "2-OUT" SIZE 100,100 OF oWnd
         oGroup3:Shadow( 2 )

         @1,40 GROUP oGroup3 LABEL "3-ETCHED_OUT" SIZE 120,100 OF oWnd
         oGroup3:Shadow( 3 )

         // Alineaciones
	 @12,1 GROUP oGroup4 LABEL "Izquierda arriba" SIZE 150,100 OF oWnd
         oGroup4:Shadow( 3 ) ; oGroup4:SetAlign(0,1)

	 @12,16 GROUP oGroup4 LABEL "Centrado Centro" SIZE 150,100 OF oWnd
         oGroup4:Shadow( 3 ) ; oGroup4:SetAlign(0.5,0.5)

	 @12,32 GROUP oGroup4 LABEL "Derecha Abajo" SIZE 150,100 OF oWnd
         oGroup4:Shadow( 1 ) ; oGroup4:SetAlign(1,0)

	 oWnd:Center()  // Centrado la ventana

	 ACTIVATE WINDOW oWnd

RETURN NIL
