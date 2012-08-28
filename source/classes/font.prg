#include "FiveLinux.ch"

CLASS TFont

   DATA   hFont  // An internal handle of the font

   METHOD New( cFontName ) INLINE ::hFont := CreateFont( cFontName ), Self

   METHOD End() INLINE DestroyFont( ::hFont ), hFont := nil

ENDCLASS
