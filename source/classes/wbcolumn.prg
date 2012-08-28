#include "FiveLinux.ch"

CLASS TWBColumn

   DATA   cHeading   // The heading text of the column
   DATA   bBlock     // A codeblock to retrive the column data to display
   DATA   nWidth     // The width of the column

   METHOD New( cHeading, bBlock, nWidth )

ENDCLASS

METHOD New( cHeading, bBlock, nWidth ) CLASS TWBColumn

   DEFAULT nWidth := 100

   ::cHeading = cHeading
   ::bBlock   = bBlock
   ::nWidth   = nWidth

return Self
