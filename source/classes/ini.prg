// ini files management based on Harbour ini files support functions

#include "FiveLinux.ch"

static oIni

//----------------------------------------------------------------------------//

CLASS TIni

   DATA   cFileName
   DATA   hIni
   DATA   lKeyCaseSens

   METHOD New( cFileName, lKeyCaseSens )

   METHOD Write() INLINE hb_iniWrite( ::cFileName, ::hIni )

   METHOD Set( cSection, cEntry, uValue )

   METHOD Get( cSection, cEntry, uDefault ) INLINE ;
             If( HB_HHASKEY( ::hIni, cSection ) .and. HB_HHASKEY( ::hIni[ cSection ], cEntry  ),;
                 ::hIni[ cSection ][ cEntry ], uDefault )    

   METHOD AddSection( cSection ) INLINE ::hIni[ cSection ] := hb_Hash()

   METHOD ClearSection( cSection ) INLINE ::AddSection( cSection ), ::Write()

   METHOD End() VIRTUAL

   #ifdef __HARBOUR__
      ERROR HANDLER OnError( uParam1 )
   #else
      ERROR HANDLER OnError( cMsg, nError )
   #endif

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cFileName, lKeyCaseSens ) CLASS TIni

   DEFAULT lKeyCaseSens := .T.

   ::cFileName    = cFileName
   ::lKeyCaseSens = lKeyCaseSens 
   ::hIni         = hb_iniRead( cFileName, lKeyCaseSens )

   oIni = Self

return Self

//----------------------------------------------------------------------------//

METHOD Set( cSection, cEntry, uValue ) CLASS TIni

   if ! HB_HHASKEY( ::hIni, cSection )
      ::hIni[ cSection ] = hb_Hash()
   endif

   ::hIni[ cSection ][ cEntry ] = uValue

return nil 

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

function EndIni()

   oIni:Write()
   oIni:End()
   oIni = nil

return nil

//----------------------------------------------------------------------------//
