#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TWBColumn

   DATA   cHeading   // The heading text of the column
   DATA   bBlock     // A codeblock to retrive the column data to display
   DATA   nWidth     // The width of the column
   DATA   oBrw       // container browse

   METHOD New( cHeading, bBlock, nWidth, oBrw )

   METHOD GetCellPos()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cHeading, bBlock, nWidth, oBrw ) CLASS TWBColumn

   DEFAULT nWidth := 100

   ::cHeading = cHeading
   ::bBlock   = bBlock
   ::nWidth   = nWidth
   ::oBrw     = oBrw

return Self

//----------------------------------------------------------------------------//

METHOD GetCellPos() CLASS TWBColumn

   local aPos := { ::oBrw:nRowPos * 20,}
   local nCol := 0, n := ::oBrw:nColPos

   while ! ::oBrw:aColumns[ n ] == Self
      nCol += ::oBrw:aColumns[ n++ ]:nWidth
   end 

   aPos[ 2 ] = nCol 

return aPos

//----------------------------------------------------------------------------//
