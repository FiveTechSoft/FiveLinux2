#include "FiveLinux.ch"

static oPrinter

CLASS TPrinter

   DATA   hJob     // An internal handle of the printer job
   DATA   hGpc     // an internal handle of the gnome print context
   DATA   nPage    // the current built page

   METHOD New( lUser )

   METHOD Choose( cTitle ) INLINE PrnDialog( ::hJob, cTitle )

   METHOD End() INLINE PrnEnd( ::hJob, ::hGpc )

   METHOD nWidth() INLINE PrnGetWidth( ::hJob )

   METHOD nHeight() INLINE PrnGetHeight( ::hJob )

   METHOD StartPage() INLINE ;
      PrnStartPage( ::hGpc, AllTrim( Str( ::nPage++ ) ) )

   METHOD EndPage() INLINE PrnEndPage( ::hGpc )

   METHOD SetPos( nRow, nCol ) INLINE PrnMoveTo( ::hGpc, nCol, nRow )

   METHOD Say( nRow, nCol, cText ) INLINE ::SetPos( nRow, nCol ),;
                                          PrnSay( ::hGpc, cText )

   METHOD Line( nTop, nLeft, nBottom, nRight ) INLINE ;
      ::SetPos( nTop, nLeft ), PrnLine( ::hGpc, nBottom, nRight )

ENDCLASS

METHOD New( lUser ) CLASS TPrinter

   DEFAULT lUser := .f.

   ::hJob  = CreatePrinter()
   ::hGpc  = PrnGetGpc( ::hJob )
   ::nPage = 1

   if lUser
      ::Choose( "Select a printer" )
   endif

return Self

function PrintBegin( lUser )

return oPrinter := TPrinter():New( lUser )

function PrintEnd()

   oPrinter:End()
   oPrinter = nil

return nil

function PageBegin()

return oPrinter:StartPage()

function PageEnd()

return oPrinter:EndPage()
