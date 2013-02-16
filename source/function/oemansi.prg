// OemToAnsi() and AnsiToOem() for Pocket PC
// Please change cOem and cAnsi for your specific language values

function OemToAnsi( cText )

   local cOem  := "¤¥ ‚΅Ά£"
   local cAnsi := "ρΡαινσϊό"
   local n
   
   for n = 1 to Len( cOem )
      cText = StrTran( cText, SubStr( cOem, n, 1 ), SubStr( cAnsi, n, 1 ) )
   next
   
return cText    

function AnsiToOem( cText )

   local cOem  := "¤¥ ‚΅Ά£"
   local cAnsi := "ρΡαινσϊό"
   local n
   
   for n = 1 to Len( cOem )
      cText = StrTran( cText, SubStr( cAnsi, n, 1 ), SubStr( cOem, n, 1 ) )
   next
   
return cText        