#include "FiveLinux.ch"

function Main()

   local oWnd, oBar

   SET DATE ITALIAN

   CreaDataBases()
   // UsaDataBases()

   DEFINE WINDOW oWnd TITLE "ContaLux" ;
      MENU BuildMenu()

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON OF oBar RESOURCE "gtk-new"

   DEFINE BUTTON OF oBar RESOURCE "gtk-quit" GROUP ACTION oWnd:End()

   ACTIVATE WINDOW oWnd MAXIMIZED

return nil

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM "Empresas"
      MENUITEM "Cuentas"
      MENUITEM "_Diarios"
      MENU
         MENUITEM "Nuevo" RESOURCE "gtk-new" ACTION DiarioNuevo()
      ENDMENU
   ENDMENU

return oMenu

function CreaDataBases()

   if ! File( "diario.dbf" )

      DbCreate( "diario.dbf", { { "fecha",   "D",  8, 0 },;
                                { "cuenta",  "N",  6, 0 },;
				{ "doc",     "N",  3, 0 },;
				{ "descrip", "C", 20, 0 },;
				{ "dh",      "C",  1, 0 },;
				{ "importe", "N", 15, 0 } } )
   endif

return nil

function UsaDataBases()

   USE "diario.dbf"

return nil

function DiarioNuevo()

   local oDlg, oBrw, oGet
   local dFecha := Date(), cCuenta := Space( 9 ), nDoc := 1,;
         cDescrip := Space( 20 ), cDH := "D", nImporte := 0

   DEFINE DIALOG oDlg TITLE "Nuevo diario" SIZE 750, 500

   @ 2, 12 SAY "Cuenta:" SIZE 100, 20
   @ 2, 47 SAY "Saldo:"  SIZE 100, 20

   @ 5, 2 BROWSE oBrw ;
      HEADERS "Fecha", "Cuenta", "Doc", "Descripción", "DH", "Importe" ;
      FIELDS  Transform( dFecha, "@D" ), cCuenta, nDoc, cDescrip, cDH,;
              nImporte ;
      SIZES   60, 100, 35, 300, 30, 200 ;
      SIZE    700, 340

   @ 42, 10 SAY "Total debe:"  SIZE 100, 20
   @ 42, 30 SAY "Total haber:" SIZE 100, 20
   @ 42, 50 SAY "Diferencia:"  SIZE 100, 20

   @ 7, 2 GET oGet VAR dFecha PICTURE "@D" SIZE 60, 22

   oGet:Cargo = 1 // cell to be edited
   oGet:bKeyDown = { | nKey | GetProcessKey( oGet, nKey, oBrw, @dFecha,;
                              @cCuenta, @nDoc, @cDescrip, @cDH, @nImporte ) }
   oGet:bLostFocus = { || oGet:Hide() }

   @ 46, 25 BUTTON "" RESOURCE "gtk-cancel" ACTION oDlg:End()
   @ 46, 39 BUTTON "" RESOURCE "gtk-ok"     ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

return nil

function GetProcessKey( oGet, nKey, oBrw, dFecha, cCuenta, nDoc, cDescrip,;
                        cDH, nImporte )

   do case
      case nKey == K_ESC
           oGet:Hide()
	   oBrw:SetFocus()
	   return .t. // don't process it further

      case nKey == K_ENTER .and. oGet:Cargo == Len( oBrw:aColumns )
           USE diario
	   diario->( DbAppend() )
	   diario->fecha   := dFecha
	   diario->cuenta  := Val( cCuenta )
	   diario->doc     := nDoc
	   diario->descrip := cDescrip
	   diario->importe := nImporte
	   USE

      case ( nKey == K_ENTER .or. nKey == K_DOWN ) .and. ;
           oGet:Cargo < Len( oBrw:aColumns )
           SetCoors( oGet:hWnd, oGet:nTop,;
                     oGet:nLeft + oBrw:aColumns[ oGet:Cargo ]:nWidth - 1  )
           if oGet:nLeft + oBrw:aColumns[ oGet:Cargo + 1 ]:nWidth > ;
	      oBrw:nWidth
              SetSize( oGet:hWnd, oBrw:nWidth - oGet:nLeft + 20, 22 )
           else
              SetSize( oGet:hWnd, oBrw:aColumns[ oGet:Cargo + 1 ]:nWidth, 22 )
           endif
           oGet:Cargo++

	   do case
	      case oGet:Cargo == 1 // Fecha
	           oGet:oGet = GetNew( -1, -1, bSETGET( dFecha ), "", "@D" )

	      case oGet:Cargo == 2 // Cuenta
	           oGet:oGet = GetNew( -1, -1, bSETGET( cCuenta ), "" )

	      case oGet:Cargo == 3 // documento
	           oGet:oGet:Assign()
	           oGet:oGet = GetNew( -1, -1, bSETGET( nDoc ), "", "999" )

	      case oGet:Cargo == 4 // descripción
	           oGet:oGet = GetNew( -1, -1, bSETGET( cDescrip ), "", "@!" )

	      case oGet:Cargo == 5 // DH
	           oGet:oGet:Assign()
	           oGet:oGet = GetNew( -1, -1, bSETGET( cDH ), "", "A" )

	      case oGet:Cargo == 6 // Importe
	           oGet:oGet:Assign()
	           oGet:oGet = GetNew( -1, -1, bSETGET( nImporte ), "" )
	   endcase

           oGet:oGet:SetFocus()
	   oGet:Refresh()

      case nKey == K_UP .and. oGet:Cargo > 1
           SetCoors( oGet:hWnd, oGet:nTop,;
                     oGet:nLeft - oBrw:aColumns[ oGet:Cargo - 1 ]:nWidth + 1 )
           SetSize( oGet:hWnd, oBrw:aColumns[ oGet:Cargo - 1 ]:nWidth, 22 )
           oGet:Cargo--

	   do case
	      case oGet:Cargo == 1 // Fecha
	           oGet:oGet = GetNew( -1, -1, bSETGET( dFecha ), "", "@D" )

	      case oGet:Cargo == 2 // Cuenta
	           oGet:oGet = GetNew( -1, -1, bSETGET( cCuenta ), "" )

	      case oGet:Cargo == 3 // documento
	           oGet:oGet = GetNew( -1, -1, bSETGET( nDoc ), "", "999" )

	      case oGet:Cargo == 4 // descripción
	           oGet:oGet = GetNew( -1, -1, bSETGET( cDescrip ), "", "@!" )
	   endcase

           oGet:oGet:SetFocus()
	   oGet:Refresh()

   endcase

return nil
