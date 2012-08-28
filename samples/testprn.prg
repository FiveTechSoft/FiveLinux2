#include "FiveLinux.ch"

function Main()

   local oPrn, nRow, nRowHeight

   PRINTER oPrn FROM USER

      nRowHeight = oPrn:nHeight / 40

      PAGE
         /*
         for nRow = 1 to 40
            oPrn:Line( nRow * nRowHeight,  0, nRow * nRowHeight, oPrn:nWidth )
	 next */
         oPrn:Say( 150, 150, "One" )
         oPrn:Say( 170, 150, "Two" )
         oPrn:Say( 190, 150, "Three" )
      ENDPAGE

   ENDPRINTER

return nil
