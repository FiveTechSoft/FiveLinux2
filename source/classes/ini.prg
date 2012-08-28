// ini files management based on Harbour ini files support functions

#include "FiveLinux.ch"

//----------------------------------------------------------------------------//

CLASS TIni

   DATA   cFileName
   DATA   hIni
   DATA   lKeyCaseSens

   METHOD New( cFileName, lKeyCaseSens )

   METHOD Write() INLINE hb_iniWrite( ::cFileName, ::hIni )

   METHOD Add( cSection, cEntry, uValue )

   METHOD AddSection( cSection ) INLINE ::hIni[ cSection ] := hb_Hash()

   METHOD ClearSection( cSection ) INLINE ::AddSection( cSection ), ::Write()

   #ifdef __HARBOUR__
      ERROR HANDLER OnError( uParam1 )
   #else
      ERROR HANDLER OnError( cMsg, nError )
   #endif

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cFileName, lKeyCaseSens ) CLASS TIni

   DEFAULT lKeyCaseSens := .F.

   ::cFileName    = cFileName
   ::lKeyCaseSens = lKeyCaseSens 
   ::hIni         = hb_iniRead( cFileName, lKeyCaseSens )

return Self

//----------------------------------------------------------------------------//

METHOD Add( cSection, cEntry, uValue ) CLASS TIni

   if ! HB_HHASKEY( ::hIni, cSection )
      ::hIni[ cSection ] = hb_Hash()
   endif

   ::hIni[ cSection ][ cEntry ] = uValue

return hb_IniWrite( ::cFileName, ::hIni )  

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   METHOD OnError( uParam1 ) CLASS TIni
      local cMsg   := __GetMessage()
      local nError := If( SubStr( cMsg, 1, 1 ) == "_", 1005, 1004 )
#else
   METHOD OnError( cMsg, nError ) CLASS TIni
      local uParam1 := GetParam( 1, 1 )
#endif

return If( HB_HHASKEY( ::hIni, cMsg ), ::hIni[ cMsg ], {} ) 

//----------------------------------------------------------------------------//
