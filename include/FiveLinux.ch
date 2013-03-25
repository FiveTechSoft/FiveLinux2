#ifndef __FIVELINUX_CH
#define __FIVELINUX_CH

#include "hbclass.ch"
#include "msgs.h"
#include "colors.ch"
#include "ini.ch"

#define K_ENTER     65293
#define K_ESC       65307
#define K_HOME      65360
#define K_END       65367
#define K_PAGEUP    65365
#define K_PAGEDOWN  65366
#define K_UP        65362
#define K_DOWN      65364
#define K_TAB       65289
#define K_LEFT      65361
#define K_RIGHT     65363
#define K_DEL       65535
#define K_BS        65288
#define K_SHIFT     65505
#define K_RSHIFT    65506
#define K_CTRL      65507
#define K_UPPER     65509
#define K_KEYPAD0   65456

extern ErrorLink

#xcommand DEFAULT <uVar1> := <uVal1> ;
               [, <uVarN> := <uValN> ] => ;
                  <uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
                [ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]

#define bSETGET(x)  {|u| If( PCount() == 0, x, x := u ) }

#define CRLF Chr( 10 )

/* TRY / CATCH / FINALLY / END */
#xcommand TRY  => BEGIN SEQUENCE WITH { | oErr | Break( oErr ) }
#xcommand CATCH [<!oErr!>] => RECOVER [ USING <oErr> ] <-oErr->
#xcommand FINALLY => ALWAYS

#xcommand ? [ <list,...> ] => [ AEval( \{ <list> \}, { | u | MsgInfo( u ) } ) ]

#xcommand SET RESOURCES TO <cFileName> => SetResources( <cFileName> ) 

#xcommand DATABASE <oDbf> => <oDbf> := TDataBase():New()

#xcommand DEFINE WINDOW <oWnd> ;
             [ TITLE <cTitle> ] ;
	     [ MENU <oMenu> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	  => ;
	     <oWnd> := TWindow():New( [<cTitle>], [<oMenu>],;
	     <nWidth>, <nHeight>, <(oWnd)> )

#xcommand ACTIVATE WINDOW <oWnd> ;
             [ VALID <uValid> ] ;
	     [ ON [ LEFT ] CLICK <uLClick> ] ;
	     [ ON RIGHT CLICK <uRClick> ] ;
	     [ <max: MAXIMIZED> ] ;
	     [ <center: CENTER, CENTERED> ] ;
	     [ ON RESIZE <uResize> ] ;
          => ;
             <oWnd>:Activate( [ \{|o| <uValid> \} ],;
             [ \{|o| <uLClick> \} ],;
	     [ \{|o| <uRClick> \} ], <.max.>, <.center.>,;
             [ \{| nWidth, nHeight, this | <uResize> \} ] )

#xcommand DEFINE DIALOG <oDlg> ;
             [ TITLE <cTitle> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
             [ RESOURCE <cResName> ] ;
	  => ;
	     <oDlg> := TDialog():New( [<cTitle>],;
	     [<nWidth>], [<nHeight>], <cResName> )

#xcommand ACTIVATE DIALOG <oDlg> ;
             [ VALID <uValid> ] ;
	     [ ON [ LEFT ] CLICK <uLClick> ] ;
	     [ ON RIGHT CLICK <uRClick> ] ;
	     [ <center: CENTER, CENTERED> ] ;
	     [ <NoModal: NOWAIT, NOMODAL> ] ;
	  => ;
             <oDlg>:Activate( <.center.>, [ \{|o| <uValid> \} ],;
	     [ \{|o| <uLClick> \} ],;
	     [ \{|o| <uRClick> \} ], [ ! <.NoModal.> ] )

#xcommand DEFINE BUTTONBAR [<oBar>] ;
	     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	  => ;
	     [ <oBar> := ] TBar():New( [<oWnd>],;
	     <nWidth>, <nHeight> )

#xcommand DEFINE BUTTON [<oBtn>] ;
	     [ OF <oBar> ] ;
	     [ <label: LABEL, PROMPT> <cText> ] ;
	     [ <img: IMAGE, FILENAME, RESOURCE> <cImgName> ] ;
	     [ ACTION <uAction> ] ;
	     [ <group: GROUP> ] ;
	  => ;
	     [ <oBtn> := ] TButton():NewBar( [<oBar>], <cText>,;
	     <cImgName>, [ \{|o|<uAction>\} ], <.group.> )

#xcommand DEFINE CLIPBOARD <oClp> => <oClp> := TClipboard():New()

#xcommand @ <nRow>, <nCol> BROWSE <oBrw> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <headers: HEAD, HEADER, HEADERS, TITLE> <cHeading,...> ] ;
             [ FIELDS <Expr1> [,<ExprN>] ] ;
             [ <sizes: FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
             [ FIELDS <Expr1> [,<ExprN>] ] ;
             [ ALIAS <cAlias> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	     [ <update: UPDATE> ] ;
	     [ ON CHANGE <uChange> ] ;
	     [ ON DBLCLICK <uDblClick> ] ;
	     [ <design: DESIGN> ] ;       
	     [ <pixel: PIXEL> ] ;       
	  => ;
             [ <oBrw> := ] TWBrowse():New( <nRow>, <nCol>,;
	     [<oWnd>], [\{<cHeading>\}], [\{<aColSizes>\}],;
	     \{ [\{|o|<Expr1>\}] [ ,\{|o|<ExprN>\} ] \}, <cAlias>,;
	     <nWidth>, <nHeight>, <.update.>, [ \{|o| <uChange> \} ],;
             [ \{| nRow, nCol, o| <uDblClick> \} ], <.design.>,;
             <.pixel.>, <(oBrw)> )
		       
#xcommand @ <nRow>, <nCol> BUTTON [ <oBtn> PROMPT ] <cPrompt> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ ACTION <uAction> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	     [ VALID <uValid> ] ;
	     [ WHEN <uWhen> ] ;
	     [ <update: UPDATE> ] ;
	     [ <img: IMAGE, RESOURCE> <cImgName> ] ;       
	     [ FONT <oFont> ] ;
	     [ <design: DESIGN> ] ;       
	     [ <pixel: PIXEL> ] ;       
	  => ;
             [ <oBtn> := ] TButton():New( <nRow>, <nCol>,;
	     <cPrompt>, [<oWnd>], [ \{|o| <uAction> \} ],;
	     <nWidth>, <nHeight>, [ \{|o| <uValid> \} ],;
	     [ \{|o| <uWhen> \} ], <.update.>, <cImgName>, [ <oFont> ],;
             [<.design.>], [<.pixel.>], <(oBtn)> )

#xcommand REDEFINE BUTTON [ <oBtn> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ ID <cId> ] ;
	     [ ACTION <uAction> ] ;
	     [ VALID <uValid> ] ;
	     [ WHEN <uWhen> ] ;
	     [ <update: UPDATE> ] ;
	     [ FONT <oFont> ] ;
	  => ;
             [ <oBtn> := ] TButton():Redefine( <cId>,;
             [<oWnd>], [ \{|o| <uAction> \} ],;
	     [ \{|o| <uValid> \} ],;
	     [ \{|o| <uWhen> \} ], <.update.>, [ <oFont> ] )

#xcommand @ <nRow>, <nCol> CHECKBOX [ <oCbx> VAR ] <lVar> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ PROMPT <cPrompt> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	     [ WHEN <uWhen> ] ;
	     [ VALID <uValid> ] ;
	     [ <update: UPDATE> ] ;
	     [ <design: DESIGN> ] ;       
	     [ <pixel: PIXEL> ] ;    
	     [ ON CHANGE <uChange> ] ;   
	  => ;
             [ <oCbx> := ] TCheckBox():New( <nRow>, <nCol>,;
	     <cPrompt>, [<oWnd>], bSETGET( <lVar> ),;
	     <nWidth>, <nHeight>, [ \{|o| <uWhen> \} ],;
	     [ \{|o| <uValid> \} ], <.update.>, <.design.>,;
             <.pixel.>, <(oCbx)>, [ \{|o| <uChange> \} ] )

#xcommand @ <nRow>, <nCol> COMBOBOX [ <oCbx> VAR ] <cVar> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ <items: PROMPTS, ITEMS> <aItems> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	     [ WHEN <uWhen> ] ;
	     [ VALID <uValid> ] ;
	     [ <update: UPDATE> ] ;
	     [ ON CHANGE <uChange> ] ;
	     [ <design: DESIGN> ] ;       
	     [ <pixel: PIXEL> ] ;       
	  => ;
             [ <oCbx> := ] TComboBox():New( <nRow>, <nCol>,;
	     [<oWnd>], bSETGET( <cVar> ), <aItems>, <nWidth>,;
	     <nHeight>, [ \{|o| <uWhen> \} ],;
	     [ \{|o| <uValid> \} ], <.update.>, [ \{|o| <uChange> \} ],;
             <.design.>, <.pixel.>, <(oCbx)> )

#xcommand @ <nRow>, <nCol> FOLDER [<oFolder>] ;
	     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <prm: PROMPT, PROMPTS, ITEMS> <cPrompt,...> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	     [ <update: UPDATE> ] ;
	     [ <design: DESIGN> ] ;       
	     [ <pixel: PIXEL> ] ;       
	  => ;
	     [<oFolder> := ] TFolder():New( <nRow>, <nCol>,;
	     [<oWnd>], [\{<cPrompt>\}], <nWidth>, <nHeight>,;
	     <.update.>, <.design.>, <.pixel.>, <(oFolder)> )

#xcommand @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
	     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
	     [ WHEN <uWhen> ] ;
	     [ VALID <uValid> ] ;
	     [ <memo: MULTILINE, MEMO, TEXT> ] ;
	     [ <update: UPDATE> ] ;
	     [ <pixel: PIXEL> ] ;       
	  => ;
             [ <oGet> := ] TMultiGet():New( <nRow>, <nCol>,;
	     [<oWnd>], bSETGET( <uVar> ), [<nWidth>],;
	     [<nHeight>], [ \{|o| <uWhen> \} ],;
	     [ \{|o| <uValid> \} ], <.update.>, <.pixel.> )

#xcommand @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
	     [ PICTURE <cPicture> ] ;
	     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
	     [ WHEN <uWhen> ] ;
	     [ VALID <uValid> ] ;
	     [ <update: UPDATE> ] ;
             [ <pass: PASSWORD> ] ;
             [ FONT <oFont> ] ;
	     [ <design: DESIGN> ] ;       
	     [ <pixel: PIXEL> ] ;       
	  => ;
             [ <oGet> := ] TGet():New( <nRow>, <nCol>, [<oWnd>],;
	     bSETGET( <uVar> ), <cPicture>, [<nWidth>],;
	     [<nHeight>], [ \{|o| <uWhen> \} ],;
	     [ \{|o| <uValid> \} ], <.update.>, <.pass.>, [<oFont>],;
             <.design.>, <.pixel.> )

#xcommand @ <nRow>, <nCol> GROUP [ <oGroup> ] ;
	     [ <label: LABEL, PROMPT> <cText> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
          => ;
             [ <oGroup> := ] TGroup():New( <nRow>, <nCol>,;
	     [<oWnd>], <cText>, <nWidth>, <nHeight> )

#xcommand @ <nRow>, <nCol> IMAGE [ <oImg> ] ;
             [ <file: FILENAME, FILE, DISK> <cFileName> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	     [ <update: UPDATE> ] ;
	     [ <design: DESIGN> ] ;       
	     [ <pixel: PIXEL> ] ;       
	  => ;
             [ <oImg> := ] TImage():New( <nRow>, <nCol>, [<oWnd>],;
	     <cFileName>, <nWidth>, <nHeight>, <.update.>, <(oImg)>,;
             <.design.>, <.pixel.> )

#xcommand @ <nRow>, <nCol> LISTBOX [ <oLbx> VAR ] <cnVar> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ <items: PROMPT, PROMPTS, ITEMS> <aItems> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	     [ WHEN <uWhen> ] ;
	     [ VALID <uValid> ] ;
	     [ <update: UPDATE> ] ;
	     [ <design: DESIGN> ] ;       
	     [ <pixel: PIXEL> ] ;       
	  => ;
             [ <oLbx> := ] TListBox():New( <nRow>, <nCol>,;
	     [<oWnd>], bSETGET( <cnVar> ), <aItems>, <nWidth>,;
	     <nHeight>, [ \{|o| <uWhen> \} ],;
	     [ \{|o| <uValid> \} ], <.update.>, <.design.>, <.pixel.>,;
             <(oLbx)> )

#xcommand @ <nRow>, <nCol> <met: METER, PROGRESS> [ <oMeter> VAR ] <nVar> ;
             [ TOTAL <nTotal> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	     [ <update: UPDATE> ] ;
	  => ;
             [ <oMeter> := ] TProgress():New( <nRow>, <nCol>,;
	     [<oWnd>], bSETGET( <nVar> ), <nTotal>, <nWidth>,;
	     <nHeight>, <.update.> )

#xcommand @ <nRow>, <nCol> RADIO [ <oRadMenu> VAR ] <nVar> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ <items: PROMPT, PROMPTS, ITEMS> <acItems> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	     [ WHEN <uWhen> ] ;
	     [ VALID <uValid> ] ;
	     [ <update: UPDATE> ] ;
       => ;
             [ <oRadMenu> := ] TRadMenu():New( <nRow>, <nCol>,;
	     [<oWnd>], bSETGET( <nVar> ), <acItems>, <nWidth>,;
	     <nHeight>, [ \{|o| <uWhen> \} ],;
	     [ \{|o| <uValid> \} ], <.update.> )

#xcommand @ <nRow>, <nCol> SAY [ <oSay> <label: PROMPT, VAR> ] <cText> ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ SIZE <nWidth>, <nHeight> ] ;
	     [ <update: UPDATE> ] ;
	     [ FONT <oFont> ] ;
	     [ <pixel: PIXEL> ] ;       
	     [ <design: DESIGN> ] ;       
       => ;
             [ <oSay> := ] TSay():New( <nRow>, <nCol>, [<oWnd>],;
	     <cText>, [<nWidth>], [<nHeight>], <.update.>, [ <oFont> ],;
             <.pixel.>, <.design.>, <(oSay)> )

#xcommand @ <nRow>, <nCol> SCROLLBAR [ <oSbr> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
	     [ <v: VERTICAL> ] ;
	     [ <h: HORIZONTAL> ] ;
	     [ <dn: DOWN, ON DOWN> <uDownAction> ] ;
	     [ <up: UP, ON UP> <uUpAction> ] ;
	     [ <pos: ON THUMBPOS> <uPos> ] ;
	     [ <pixel: PIXEL> ] ;       
	     [ <design: DESIGN> ] ;       
	  => ;
             [ <oSbr> := ] TScrollbar():New( <nRow>, <nCol>,;
	     [<oWnd>], <nWidth>, <nHeight>,;
	     (.not. <.h.> ) [ .or. <.v.> ],;
	     [\{|o|<uDownAction>\}], [\{|o|<uUpAction>\}],;
	     [\{|nPos| <uPos> \}], <.pixel.>, <.design.>, <(oSbr)> )

#xcommand MENU [ <oObjMenu> ] ;
	     [ <popup: POPUP> ] ;
          => ;
	     [ <oObjMenu> := ] MenuBegin( <.popup.> )

#xcommand MENUITEM [ <oMenuItem> PROMPT ] [<cPrompt>] ;
	     [ ACTION <uAction> ] ;
	     [ <resource: RESOURCE, NAME, RESNAME> <cResName> ] ;
             [ MESSAGE <cMsg> ] ;
          => ;
	     [ <oMenuItem> := ] MenuAddItem( <cPrompt>,;
	     [ \{|o| <uAction> \} ], <cResName>, <cMsg> )

#xcommand SEPARATOR [ <oMenuItem> ] => MenuAddItem()

#xcommand ENDMENU => MenuEnd()

#xcommand ACTIVATE <menu: MENU, POPUP> <oMenu> ;
	     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ AT <nRow>, <nCol> ] ;
          => ;
	     <oMenu>:Activate( <nRow>, <nCol>, <oWnd> )

#xcommand <set: SET, DEFINE> <msg: MESSAGE, MESSAGE BAR, MSGBAR> [<oBar>] ;
 	     [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
	     [ <to: TO, PROMPT> <cMsg> ] ;
	     [ <update: UPDATE> ] ;
          => ;
	     [<oBar> := ] TMsgBar():New( <oWnd>, <cMsg>, <.update.> )

#xcommand PRINTER <oPrn> ;
	     [ <user: FROM USER> ] ;
          => ;
	     <oPrn> := PrintBegin( <.user.> )

#xcommand PAGE => PageBegin()

#xcommand ENDPAGE => PageEnd()

#xcommand ENDPRINT => PrintEnd()
#xcommand ENDPRINTER => PrintEnd()

#xcommand DEFINE TIMER [ <oTimer> ] ;
             [ INTERVAL <nInterval> ] ;
             [ ACTION <uAction,...> ] ;
          => ;
             [ <oTimer> := ] TTimer():New( <nInterval>, [\{||<uAction>\}] )

#xcommand ACTIVATE TIMER <oTimer> => <oTimer>:Activate()

#xcommand DEFINE FONT [ <oFont> ] ;
             [ NAME <cName> ] ;
          => ;
             [ <oFont> := ] TFont():New( <cName> )

#xcommand RELEASE <ClassName> <oObj1> [,<oObjN>] ;
          => ;
             <oObj1>:End() ; <oObj1> := nil ;
             [ ; <oObjN>:End() ; <oObjN> := nil ]

#endif
