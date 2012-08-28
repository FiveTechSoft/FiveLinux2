// Clipper DataBases management as objects

#include "FiveLinux.ch"
#include "dbinfo.ch"
#include "dbstruct.ch"
#include "hbcompat.ch"

#define DBS_EXTYPE   6
#define DBS_PIC      7
#define DBS_TAG      8
#define DBS_BLOCK    9
#define DBS_ASIZE    DBS_BLOCK

#ifdef __XPP__
   #include "Class.ch"
   #include "types.ch"
   #define _DbSkipper DbSkipper
#endif

#ifdef __HARBOUR__
   #ifndef __XHARBOUR__
      #define _DbSkipper __DbSkipper
   #else
      #define _DbSkipper DbSkipper
   #endif
   #define DbPack __DbPack
   #define DbZap  __DbZap
#endif

#define USE_HASH // use hash of fields for faster FieldPos
                 // If hash code breaks in any build of (x)Harbour ( can happen )
                 // uncomment and recompile to use standard array scan

//----------------------------------------------------------------------------//

CLASS TDataBase

   DATA   nArea                  AS NUMERIC INIT 0
   DATA   lBuffer
   DATA   lShared                AS LOGICAL INIT ! Set(_SET_EXCLUSIVE)
   DATA   aBuffer
   DATA   bBoF, bEoF, bNetError
   DATA   cAlias, cFile          AS String INIT ""
   DATA   cDriver                AS CHARACTER INIT RddSetDefault()
   DATA   lReadOnly              AS LOGICAL INIT .f.
   DATA   lOemAnsi
#ifdef __HARBOUR__
   DATA   lTenChars              AS LOGICAL INIT .f.
#else
   DATA   lTenChars              AS LOGICAL INIT .t.
#endif
   DATA   aFldNames              AS ARRAY
   DATA   aStruct                AS ARRAY
#ifdef USE_HASH
   DATA   hFlds
#endif
   DATA   Cargo

   #ifdef __XPP__
      // CLASS VAR this
   #endif

   METHOD New(  ncArea, cFile, cDriver, lShared, lReadOnly )  CONSTRUCTOR
   METHOD Open( ncArea, cFile, cDriver, lShared, lReadOnly )  CONSTRUCTOR

   METHOD Use()
   METHOD SetArea( nWorkArea )   // used internally

   METHOD Activate()

   METHOD AddIndex( cFile, cTag ) INLINE ( ::nArea )->( OrdListAdd( cFile, cTag ) )
   MESSAGE AnsiToOem METHOD _AnsiToOem()
   METHOD Append()            INLINE ( ::nArea )->( DbAppend() )

   METHOD AppendFrom( cFile, aFields, bFor, bWhile, nNext, nRec, lRest )

   METHOD Blank()
   METHOD Bof()               INLINE ( ::nArea )->( BoF() )
   METHOD Close()             INLINE ( ::nArea )->( DbCloseArea() )
   METHOD CloseIndex()        INLINE ( ::nArea )->( OrdListClear() )
   METHOD Commit()            INLINE ( ::nArea )->( DBCommit() )

   METHOD CopyTo( cFile, aFields, bFor, bWhile, nNext, nRec, cRdd, cCp )

   METHOD Create( cFile, aStruct, cDriver ) ;
                              INLINE DbCreate( cFile, aStruct, cDriver )

   METHOD CreateIndex( cFile, cTag, cKey, bKey, lUnique) INLINE ;
          ( ::nArea )->( OrdCreate( cFile, cTag, cKey, bKey, lUnique ) )

   METHOD ClearRelation()     INLINE ( ::nArea )->( DbClearRelation() )

   METHOD DbCreate( aStruct ) INLINE DbCreate( ::cFile, aStruct, ::cDriver )

   METHOD Deactivate()        INLINE ( ::nArea )->( DbCloseArea() ), ::nArea := 0

   #ifndef __XPP__
   MESSAGE Eval METHOD _Eval( bBlock, bFor, bWhile, nNext, nRecord, lRest )
   #endif

   MESSAGE Delete METHOD _Delete()
   METHOD Deleted()           INLINE ( ::nArea )->( Deleted() )

   METHOD DeleteIndex( cTag, cFile ) INLINE ( ::nArea )->( OrdDestroy( cTag, cFile ) )

   METHOD Eof()               INLINE ( ::nArea )->( EoF() )

   METHOD FCount()            INLINE Len( ::aStruct )
   MESSAGE FieldGet METHOD _FieldGet( nField )

   METHOD FieldName( nField ) INLINE If( nField > 0 .and. nField <= ::Fcount, ::aStruct[ nField, 1 ], '' )
   METHOD AddCol( cCol, cType, nLen, nDec, bBlock )
   METHOD MapCol( cFld, cNewName )
   MESSAGE FieldPos          METHOD TD_FieldPos
   METHOD TD_FieldPos( cFieldName )
   MESSAGE FieldBlock        METHOD _FieldBlock
   MESSAGE FieldWBlock       METHOD _FieldBlock
   METHOD _FieldBlock( cnCol )

   METHOD FieldType( n, c ) INLINE If( c == nil, ::aStruct[ n ][ 2 ], ::aStruct[ n ][ 2 ] := c )

   MESSAGE FieldPut METHOD _FieldPut( nField, uVal )

   METHOD Found()             INLINE ( ::nArea )->( Found() )

   METHOD GoTo( nRecNo )      INLINE ( ::nArea )->( DBGoTo( nRecNo ) ),;
                                     If( ::lBuffer, ::Load(), )

   METHOD GoTop()             INLINE ( ::nArea )->( DBGoTop() ),;
                                     If( ::lBuffer, ::Load(), )
   METHOD GoBottom()          INLINE ( ::nArea )->( DBGoBottom() ),;
                                     If( ::lBuffer, ::Load(), )

   METHOD IndexKey( ncTag, cFile )   INLINE ( ::nArea )->( OrdKey( ncTag, cFile ) )
   METHOD IndexName( nTag, cFile )   INLINE ( ::nArea )->( OrdName( nTag, cFile ) )
   METHOD IndexBagName( nInd )       INLINE ( ::nArea )->( OrdBagName( nInd ) )
   METHOD IndexOrder( cTag, cFile )  INLINE ( ::nArea )->( OrdNumber( cTag, cFile ) )

   METHOD LastRec()           INLINE ( ::nArea )->( LastRec() )

   METHOD Load()
   METHOD RollBack()

   METHOD Lock()              INLINE ( ::nArea )->( FLock() )
   METHOD RecLock( nRecNo )
   METHOD IsRecLocked( nRecNo )
   METHOD UnLock()            INLINE ( ::nArea )->( DBUnLock() )
   METHOD RecUnLock( nRecNo )

   METHOD Modified()
   METHOD Updated()

   MESSAGE OemToAnsi METHOD _OemToAnsi()
   METHOD Pack()              INLINE ( ::nArea )->( DbPack() )
   METHOD ReCall()

   METHOD RecCount()          INLINE ( ::nArea )->( RecCount() )
   METHOD RecNo()             INLINE ( ::nArea )->( RecNo() )
   METHOD KeyNo()             INLINE ( ::nArea )->( OrdKeyNo() )
   METHOD KeyGoTo( nkeyNo )   INLINE ( ( ::nArea )->( OrdKeyGoTo( nKeyNo ) ), ::Load() )
   METHOD KeyCount()          INLINE ( ::nArea )->( OrdKeyCount() )
   METHOD BookMark( u )       INLINE ( If( u != nil, ::GoTo( u ), ), ::RecNo() )

   METHOD Save()
   METHOD SaveBuff()

   METHOD SetBuffer( lOnOff ) // if TRUE reloads buffer, return lBuffer.

#ifdef __HARBOUR__
   METHOD Seek( uExp, lSoft, lWildSeek, lCurRec )
#else
   METHOD Seek( uExp, lSoft )
#endif

   METHOD SetOrder( cnTag, cFile )    INLINE ( ::nArea )->( OrdSetFocus( cnTag, cFile ) )
   METHOD OrdDescend( cnTag, cFile, lDesc ) INLINE ( ::nArea )->( OrdDescend( cnTag, cFile, lDesc ) )
   METHOD SetRelation( oncArea, cExp, lScoped )
   METHOD SetFilter( cFilter )
   METHOD ordScope( nScopeType, uValue )

   METHOD Skip( nRecords )
   METHOD Skipper( nRecords )

   METHOD Used()              INLINE ( ::nArea )->( Used() )
   METHOD Zap()               INLINE ( ::nArea )->( DbZap() )

#ifdef __HARBOUR__
   METHOD SetXBrowse( oBrw, aCols, lAutoSort, lAutocols )
   MESSAGE xBrowse METHOD _xBrowse
   METHOD _xBrowse( oWnd, aCols, lAutoSort, bSetUp )
#endif

   #ifdef __HARBOUR__
      ERROR HANDLER OnError( uParam1 )
   #else
      ERROR HANDLER OnError( cMsg, nError )
   #endif

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( ncArea, cFile, cDriver, lShared, lReadOnly ) CLASS TDataBase

   if PCount() > 1
      if ValType( ncArea ) == 'C'
         ::cAlias    = ncArea
      endif
      if ValType( cFile ) == 'C'
         ::cFile     = cFile
      endif
      if ValType( cDriver ) == 'C'
         ::cDriver   = Upper( cDriver )
      endif
      if ValType( lShared ) == 'L'
         ::lShared   = lShared
      endif
      if ValType( lReadOnly ) == 'L'
         ::lReadOnly = lReadOnly
      endif
   else
      DEFAULT ncArea := Select()

      if ValType( ncArea ) == 'N' .and. ( ncArea )->( Used() )
         ::SetArea( ncArea )
      elseif ValType( ncArea ) == 'C'
         if ( ncArea )->( Used() )
            ::SetArea( Select( ncArea ) )
         elseif File( ncArea )
            ::cFile  = ncArea
         endif
      endif
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Open( cAlias, cFile, cDriver, lShared, lReadOnly ) CLASS TDataBase

   if ValType( cAlias ) == 'C'
      ::cAlias    = cAlias
   endif
   if ValType( cFile ) == 'C'
      ::cFile     = cFile
   endif
   if ValType( cDriver ) == 'C'
      ::cDriver   = Upper( cDriver )
   endif
   if ValType( lShared ) == 'L'
      ::lShared   = lShared
   endif
   if ValType( lReadOnly ) == 'L'
      ::lReadOnly = lReadOnly
   endif

   ::Use()

return Self

//----------------------------------------------------------------------------//

METHOD Use() CLASS TDataBase

   if Empty( ::cAlias )
      ::cAlias := cGetNewAlias( 'TDF' )
   endif
   if Select( ::cAlias ) > 0
      ::cAlias    := cGetNewAlias( Left( ::cAlias, 3 ) )
   endif

   dbUseArea( .t., ::cDriver, ::cFile, ::cAlias, ::lShared, ::lReadOnly )

   if Alias() == ::cAlias
      ::SetArea( Select() )
   endif

return ::Used()

//----------------------------------------------------------------------------//

METHOD SetArea( nWorkArea ) CLASS TDataBase

   local n, oClass, aDatas := {}, aMethods := {}, cCol

   DEFAULT nWorkArea := Select()

   ::nArea     = nWorkArea
   ::cAlias    = Alias( nWorkArea )
   ::cFile     = Alias( nWorkArea )
   if ::Used()
      ::cFile     = ( nWorkArea )->( DbInfo( DBI_FULLPATH ) )
      ::cDriver   = ( nWorkArea )->( RddName() )
      ::lShared   = ( nWorkArea )->( DbInfo( DBI_SHARED ) )
      #ifdef __HARBOUR__
         ::lReadOnly = ( nWorkArea )->( DbInfo( DBI_ISREADONLY ) )
      #else
         DEFAULT ::lReadOnly := .f.
      #endif
      DEFAULT ::lBuffer   := .t.
      DEFAULT ::lOemAnsi  := .f.

      DEFAULT ::bNetError := { || MsgStop( "Record in use", "Please, retry" ) }

      ::aStruct   = ( ::cAlias )->( DbStruct() )
      AEval( ::aStruct, { |a| ASize( a, DBS_ASIZE ) } )
      ::aFldNames := {}
#ifdef USE_HASH
      ::hFlds := {=>}
#ifdef __XHARBOUR__
      HSetCaseMatch( ::hFlds, .f. )
#else
      HB_HCaseMatch( ::hFlds, .f. )
#endif
#endif
      for n = 1 to ( ::cAlias )->( FCount() )
         cCol  := ( ::cAlias )->( FieldName( n ) )
         AAdd( ::aFldNames, cCol )
#ifdef USE_HASH
         ::hFlds[ cCol ] := n
#endif
         if ::aStruct[ n ][ DBS_TYPE ] == 'N'
            ::aStruct[ n ][ DBS_PIC  ] := NumPict( ::aStruct[ n ][ DBS_LEN ], ::aStruct[ n ][ DBS_DEC ] )
         endif
         #ifdef __XPP__
            // AAdd( aDatas, { ( ::cAlias )->( FieldName( n ) ),;
            //                CLASS_EXPORTED + VAR_INSTANCE } )
            AAdd( aMethods, { ( ::cAlias )->( FieldName( n ) ),;
                            CLASS_EXPORTED + METHOD_ACCESS + ;
                            METHOD_ASSIGN + METHOD_INSTANCE,;
                            GenBlock( n ),;
                            ( ::cAlias )->( FieldName( n ) ) } )
         #endif
      next
      ( ::cAlias )->( OrderTagInfo( ::aStruct, DBS_TAG ) )

      #ifdef __XPP__
         if ClassObject( Alias() ) == nil
            ClassCreate( Alias(), { TDataBase() }, aDatas, aMethods )
         // else
         //   ::this = Self
         endif
      #endif
   endif

   ::Load()

return Self

//----------------------------------------------------------------------------//

#ifdef __XPP__

static function GenBlock( n )

   local cAlias := Alias()
   local obj

// return { | m, u | obj := ClassObject( cAlias ):this,;
//               If( PCount() > 1, ( MsgInfo( u ), obj:FieldPut( n, u ) ),;
//                   obj:FieldGet( n ) ) }
return { | Self, u | If( PCount() > 1, ::FieldPut( n, u ), ::FieldGet( n ) ) }

#endif

//----------------------------------------------------------------------------//

METHOD Activate() CLASS TDataBase

   local nOldArea:= Select()

   Select ( ::nArea )
   if ! Used()
      DbUseArea( .f., ::cDriver, ::cFile, ::cAlias, ::lShared, ::lReadOnly )
   endif

   Select ( nOldArea )

return nil

//----------------------------------------------------------------------------//

METHOD AddCol( cCol, uExpr, cType, nLen, nDec, cPic, cTag ) CLASS TDataBase

   local nCol := 0
   local cKey, uVal, bBlock, n

   if ::FieldPos( cCol ) > 0
      for n := 1 to 99
         if ::FieldPos( cCol + StrZero( n, 2 ) ) == 0
            cCol  += StrZero( n, 2 )
            exit
         endi
      next n
   endif

   if ::FieldPos( cCol ) == 0
      if uExpr == nil .and. cTag != nil
         cKey     := ( ::nArea )->( OrdKey( cTag ) )
         if ! Empty( cKey )
            bBlock   := &( '{||' + cKey + '}' )
         endif
      endif

      if ValType( uExpr ) == 'B'
         bBlock   := uExpr
      elseif ValType( uExpr ) == 'C'
         bBlock   := &( '{ |Self|' + uExpr + '}' )
      else
         bBlock   := { || uExpr }
      endif

      TRY
         uVal  := ( ::nArea )->( Eval( bBlock, Self ) )
      CATCH
         bBlock   := { || uExpr }
         uVal  := uExpr
      END

      DEFAULT cType     := ValType( uVal )
      if nLen == nil
         do case
         case cType == 'L'
            nLen  := 1; nDec := 0
         case cType == 'D' .or. cType == 'T'
            nLen  := 8; nDec := 0
         case cType == 'C'
            nLen  := Len( uVal )
         case cType == 'N'
            DEFAULT nDec := If( uVal == Int( uVal ), 0, 2 )
            nLen  := Len( LTrim( Str( Int( uVal ) ) ) ) + nDec + If( nDec > 0, 1, 0 )
         otherwise
            nLen  := 10; nDec := 0
         endcase
      endif

      if cType == 'N'
         DEFAULT cPic := NumPict( nLen, nDec, nDec > 0 )
      endif

      AAdd( ::aStruct, Array( DBS_ASIZE ) )
      AAdd( ::aFldNames, '' )
      nCol                             := Len( ::aStruct )
      ::aStruct[ nCol ][ DBS_NAME ]    := cCol
      ::aStruct[ nCol ][ DBS_TYPE ]    := cType
      ::aStruct[ nCol ][ DBS_LEN  ]    := nLen
      ::aStruct[ nCol ][ DBS_DEC  ]    := nDec
      ::aStruct[ nCol ][ DBS_PIC  ]    := cPic
      ::aStruct[ nCol ][ DBS_TAG  ]    := cTag
      ::aStruct[ nCol ][ DBS_BLOCK]    := bBlock

#ifdef USE_HASH
      ::hFlds[ cCol ] := nCol
#endif

   endif

return nCol

//------------------------------------------------------------------//

METHOD MapCol( cFld, cNewName ) CLASS TDataBase

   local lDone := .f.
   local nCol

   if ValType( cFld ) == 'C' .and. ValType( cNewName ) == 'C'
      if ( nCol := AScan( ::aFldNames, Upper( cFld ) ) ) > 0 .and. ;
         ::FieldPos( cNewName ) == 0

         ::aStruct[ nCol ][ 1 ] := cNewName
#ifdef USE_HASH
         ::hFlds[ cNewName ] := nCol
#endif
         lDone := .t.
      endif
   elseif ValType( cFld ) == 'A'
      AEval( cFld, { |a| lDone := ::MapCol( a[ 1 ], a[ 2 ] ) } )
   endif

return lDone

//------------------------------------------------------------------//

METHOD TD_FieldPos( cField ) CLASS TDataBase

   local nPos

#ifdef USE_HASH
   // HB_Decode( cField, ::hFlds, 0 ) // should work but fails. Bug in both (x)Harbour
   TRY
      nPos  := ::hFlds[ cField ]
   CATCH
      nPos  := 0
   END
#else
   cField   := Upper( cField )
   if ( nPos := AScan( ::aStruct, { |a| Upper( a[ 1 ] ) == cField } ) ) == 0
      nPos  := AScan( ::aFldNames, cField )
   endif
#endif

return nPos

//------------------------------------------------------------------//

METHOD _FieldBlock( nCol ) CLASS TDataBase

   local oDbf  := Self

   if ValType( nCol ) == 'C'
      nCol     := ::FieldPos( nCol )
   endif

return { |x| If( x == nil, oDbf:FieldGet( nCol ), oDbf:FieldPut( nCol, x ) ) }

//------------------------------------------------------------------//

METHOD _AnsiToOem() CLASS TDataBase

   local n

   for n = 1 to Len( ::aBuffer )
      if ValType( ::aBuffer[ n ] ) == "C"
         ::aBuffer[ n ] = AnsiToOem( ::aBuffer[ n ] )
      endif
   next

return nil

//----------------------------------------------------------------------------//

METHOD RecLock( nRecNo ) CLASS TDataBase

   DEFAULT nRecNo := ::RecNo()

return ( ::nArea )->( DbrLock( nRecNo ) )

//----------------------------------------------------------------------------//

METHOD RecUnLock( nRecNo ) CLASS TDataBase

   if nRecNo == nil
      ( ::nArea )->( DbRUnlock() )
   else
      ( ::nArea )->( DbRUnlock( nRecNo) )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD IsRecLocked( nRecNo ) CLASS TDataBase

   DEFAULT nRecNo := ::RecNo()

return ( ::nArea )->( DbInfo( DBI_ISFLOCK ) .or. DbRecordInfo( DBRI_LOCKED, nRecNo ) )
//----------------------------------------------------------------------------//

METHOD _Delete() CLASS TDataBase

   local lLocked  := .f.
   local lDeleted := .f.

   if ! ::Eof() .and. ! ::lReadOnly .and. ! ( ::nArea )->( Deleted() )
      if ::lShared
         if ::IsRecLocked( ::RecNo() ) .or. ( lLocked := ::RecLock( ::RecNo() ) )
            ( ::nArea )->( DbDelete() )
            lDeleted := .t.
            if lLocked
               ::Commit()
               ::RecUnLock( ::RecNo() )
            endif
         else
            MsgAlert( "DataBase in use", "Please try again" )
         endif
      else
         ( ::nArea )->( DbDelete() )
         lDeleted := .t.
      endif
      if lDeleted
         if Set( _SET_DELETED ) // .or. ! Empty( ( ::nArea )->( DbFilter() ) )
            ::Skip( 1 )
            if ::Eof()
               ::GoBottom()
            endif
         endif
      endif
   endif

return lDeleted

//----------------------------------------------------------------------------//

METHOD Recall() CLASS TDataBase

   local lLocked  := .f.

   if ! ::Eof() .and. ! ::lReadOnly .and. ( ::nArea )->( Deleted() )
      if ::lShared
         if ::IsRecLocked( ::RecNo() ) .or. ( lLocked := ::RecLock( ::RecNo() ) )
            ( ::nArea )->( DbRecall() )
            if lLocked
               ::Commit()
               ::RecUnLock( ::RecNo() )
            endif
         else
            MsgAlert( "DataBase in use", "Please try again" )
         endif
      else
         ( ::nArea )->( DbRecall() )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD _FieldGet( nPos ) CLASS TDataBase

   if nPos > ( ::nArea )->( FCount() )
      return ( ::nArea )->( Eval( ::aStruct[ nPos ][ DBS_BLOCK ], Self ) )
   elseif ::lBuffer
      return ::aBuffer[ nPos ]
   else
      return ( ::nArea )->( FieldGet( nPos ) )
   endif

return nil

//---------------------------------------------------------------------------//

METHOD _FieldPut( nPos, uValue ) CLASS TDataBase

   local lLocked  := .f.
   local lCalcCol := ( nPos > ( ::nArea )->( FCount() ) )

   if ::lBuffer
      if lCalcCol
         ( ::nArea )->( Eval( ::aStruct[ nPos ][ DBS_BLOCK ], Self, uValue ) )
      else
         ::aBuffer[ nPos ] := uValue
      endif
   else
      if ::lShared
         if ! ::lReadOnly
            if ::IsRecLocked( ::RecNo() ) .or. ( lLocked := ::RecLock( ::RecNo() ) )
               if lCalcCol
                  ( ::nArea )->( Eval( ::aStruct[ nPos ][ DBS_BLOCK ], Self, uValue ) )
               else
                  ( ::nArea )->( FieldPut( nPos, uValue ) )
               endif
               if lLocked
                  ::Commit()
                  ::RecUnLock( ::RecNo() )
               endif
            else
               if ! Empty( ::bNetError )
                  return Eval( ::bNetError, Self )
               endif
            endif
         endif
      else
         ( ::nArea )->( FieldPut( nPos, uValue ) )
      endif
   endif

return ( ::nArea )->( ::FieldGet( nPos ) )

//---------------------------------------------------------------------------//

static function Compile( cExp )

return &( "{||" + cExp + "}" )

//----------------------------------------------------------------------------//

METHOD Load() CLASS TDataBase

   local n

   if ::lBuffer
      if Empty( ::aBuffer )
         ::aBuffer = Array( ::FCount() )
      endif

      for n = 1 to Len( ::aBuffer )
         #ifdef __XPP__
         //   if ( ::nArea )->( FieldType( n ) ) != "M"
         #endif
         ::aBuffer[ n ] = ( ::nArea )->( FieldGet( n ) )
         #ifdef __XPP__
         //   else
         //      ::aBuffer[ n ] = "<Memo>"
         //   endif
         #endif
      next

      if ::lOemAnsi
         ::OemToAnsi()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD RollBack() CLASS TDataBase

#ifdef __HARBOUR__
   if ( ::nArea )->( DbRecordInfo( DBRI_UPDATED ) )
      ( ::nArea )->( DbInfo( DBI_ROLLBACK ) )
   endif
#endif
   ::Load()

return nil

//----------------------------------------------------------------------------//

METHOD Modified() CLASS TDataBase

   local n

   if ::lBuffer
      for n := 1 to ( ::nArea )->( FCount() )
         if ! ( ::cAlias )->( FieldGet( n ) ) == ::aBuffer[ n ]
            return .t.
         endif
      next
   endif

return .f.

//----------------------------------------------------------------------------//

METHOD Updated() CLASS TDataBase
return ( ::nArea )->( DbRecordInfo( DBRI_UPDATED ) ) .or. ::Modified()

//----------------------------------------------------------------------------//

METHOD Blank() CLASS TDataBase

   if ::lBuffer
      AEval( ::aBuffer, { |u,i| ::aBuffer[ i ] := uValBlank( u ) } )
   endif

return .f.

//----------------------------------------------------------------------------//

METHOD _OemToAnsi() CLASS TDataBase

   local n

   for n = 1 to Len( ::aBuffer )
      if ValType( ::aBuffer[ n ] ) == "C"
         ::aBuffer[ n ] = OemToAnsi( ::aBuffer[ n ] )
      endif
   next

return nil

//----------------------------------------------------------------------------//

#ifndef __XPP__
METHOD _Eval( bBlock, bFor, bWhile, nNext, nRecord, lRest ) CLASS TDataBase

   local lSave := ::lBuffer

   ::SetBuffer( .f. )

   ( ::nArea )->( DBEval( bBlock, bFor, bWhile, nNext, nRecord, lRest ) )

   ::SetBuffer( lSave )

return nil
#endif

//----------------------------------------------------------------------------//

METHOD SetRelation( uChild, cRelation, lScoped ) CLASS TDataBase

   DEFAULT lScoped   := .f.

   if ValType( uChild ) == 'O'
      uChild   := uChild:nArea
   endif

   if lScoped
      ( ::nArea )->( OrdSetRelation( uChild, Compile( cRelation ), cRelation ) )
   else
      ( ::nArea )->( DbSetRelation( uChild, Compile( cRelation ), cRelation ) )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetFilter( cFilter ) CLASS TDataBase

   ( ::nArea )->( DbSetFilter( Compile( cFilter ), cFilter ) )

return nil

//----------------------------------------------------------------------------//

METHOD OrdScope( nScopeType, uValue ) CLASS TDataBase

return ( ::cAlias )->( OrdScope( nScopeType, uValue ) )

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
   METHOD OnError( uParam1 ) CLASS TDataBase
      local cMsg   := __GetMessage()
      local nError := If( SubStr( cMsg, 1, 1 ) == "_", 1005, 1004 )
#else
   METHOD OnError( cMsg, nError ) CLASS TDataBase
      local uParam1 := GetParam( 1, 1 )
#endif

   local nCol, cCol, lAssign := .f.

   cCol  := If( lAssign := ( Left( cMsg, 1 ) == '_' ), SubStr( cMsg, 2 ), cMsg )
   if .not. ::lTenChars .or. Len( cCol ) <= 9
      if ( nCol := ::FieldPos( cCol ) ) > 0
         return If( lAssign, ::FieldPut( nCol, uParam1 ), ::FieldGet( nCol ) )
      else
         _ClsSetError( _GenError( nError, ::ClassName(), cMsg ) )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__
METHOD Seek( uExpr, lSoft, lWildSeek, lCurRec ) CLASS TDataBase
#else
METHOD Seek( uExpr, lSoft ) CLASS TDataBase
#endif

   local lFound

   DEFAULT lSoft := Set( _SET_SOFTSEEK )

#ifdef __HARBOUR__

   If Upper( Left( ( ::nArea )->( OrdKey() ), 5 ) ) == 'UPPER'
      uExpr  := Upper( uExpr )
   endif

   DEFAULT lCurRec := .f.
   if lWildSeek == .t. .and. ValType( uExpr ) == 'C'
      lFound = ( ::nArea )->( OrdWildSeek( uExpr, lCurRec ) )
   else
      lFound = ( ::nArea )->( DbSeek( uExpr, lSoft ) )
   endif
#else
   lFound = ( ::nArea )->( DbSeek( uExpr, lSoft ) )
#endif

//   if ::lBuffer .and. ! ( ::nArea )->( Eof() )
      ::Load()
//   endif

return lFound

//----------------------------------------------------------------------------//

METHOD SetBuffer( lOnOff ) CLASS TDataBase

   DEFAULT lOnOff := .t.

   if lOnOff != nil
       ::lBuffer = lOnOff
   endif

   if ::lBuffer
      ::Load()
   else
      ::aBuffer := nil
   endif

return ::lBuffer

//----------------------------------------------------------------------------//

METHOD Save() CLASS TDataBase

   local n
   local lLocked  := .f.

   if ::lBuffer
      if ! ::Eof() .and. ! ::lReadOnly
         if ::lShared
            if ::IsRecLocked( ::RecNo() ) .or. ( lLocked := ::RecLock( ::RecNo() ) )
               ::SaveBuff()
               if lLocked
                  ::Commit()
                  ::RecUnLock( ::RecNo() )
               endif
            else
               if ! Empty( ::bNetError )
                  return Eval( ::bNetError, Self )
               else
                  MsgAlert( "Record in use", "Please, retry" )
               endif
            endif
         else
            ::SaveBuff()
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SaveBuff() CLASS TDataBase

   local n

   if ::lBuffer
      for n := 1 to Len( ::aBuffer )
         if ::lOemAnsi .and. ValType( ::aBuffer[ n ] ) == "C"
            ( ::nArea )->( FieldPut( n, AnsiToOem( ::aBuffer[ n ] ) ) )
         else
            ( ::nArea )->( FieldPut( n, ::aBuffer[ n ] ) )
         endif
      next
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Skip( nRecords ) CLASS TDataBase

   local n

   DEFAULT nRecords := 1

   ( ::nArea )->( DbSkip( nRecords ) )

   if ::lBuffer
      ::Load()
   endif

   if ::Eof()
      if ::bEoF != nil
         Eval( ::bEoF, Self )
      endif
   endif

   if ::BoF()
      if ::bBoF != nil
         Eval( ::bBoF, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Skipper( nRecords ) CLASS TDataBase

   local nSkipped

   DEFAULT nRecords := 1

   nSkipped = ( ::nArea )->( _DbSkipper( nRecords ) )

   if ::lBuffer
      ::Load()
   endif

return nSkipped

//----------------------------------------------------------------------------//

METHOD CopyTo( cFile, aFields, bFor, bWhile, nNext, nRec, cRdd, cCp ) CLASS TDataBase

   LOCAL uVal
   uVal = ( ::cAlias )->( __dbCopy( cFile, aFields, bFor, bWhile, nNext, nRec, cRdd, cCp ) )

return uVal

//----------------------------------------------------------------------------//

METHOD AppendFrom( cFile, aFields, bFor, bWhile, nNext, nRec, lRest ) CLASS TDataBase

     __dbApp( cFile, aFields, bFor, bWhile, nNext, nRec, lRest )

return nil

//----------------------------------------------------------------------------//

#ifdef __HARBOUR__

//----------------------------------------------------------------------------//

METHOD SetXBrowse( oBrw, aCols, lAutoSort, lAutoCols ) CLASS TDataBase

   local oDbf  := Self
   local nCol, cCol

   DEFAULT lAutoSort := .f., lAutoCols := ( aCols == nil )

   WITH OBJECT oBrw
      :oDbf          := oDbf
      :bGoTop        := {|| oBrw:oDbf:GoTop() }
      :bGoBottom     := {|| oBrw:oDbf:GoBottom() }
      :bSkip         := {| n | oBrw:oDbf:Skipper( If( n == nil, 1, n ) ) }
      :bBof          := {|| oBrw:oDbf:Bof() }
      :bEof          := {|| oBrw:oDbf:Eof() }
      :bBookMark     := { |u| oBrw:oDbf:BookMark( u ) }
      :bKeyNo        := { |n| If( n == nil, oBrw:oDbf:KeyNo(), oBrw:oDbf:KeyGoTo( n ) ) }
      :bKeyCount     := { || oBrw:oDbf:KeyCount() }
      :nDataType     := DATATYPE_ODBF
      :bOnRowLeave   := { || oBrw:oDbf:Save() }
      :bSeek         := { |c| oBrw:oDbf:Seek( c, , oBrw:lSeekWild ) }
   END

   if aCols == nil .and. lAutoCols
      aCols := {}
      AEval( ::aStruct, { |a| AAdd( aCols, a[ 1 ] ) } )
   endif

   if ! Empty( aCols )
      for each cCol in aCols
         WITH OBJECT oBrw:AddCol()
            :cHeader    := cCol
            if ( nCol := ::FieldPos( cCol ) ) > 0
               :bEditValue := ::FieldBlock( nCol )
               :cDataType  := ::aStruct[ nCol ][ DBS_TYPE ]
               :nDataLen   := ::aStruct[ nCol ][ DBS_LEN  ]
               :nDataDec   := ::aStruct[ nCol ][ DBS_DEC  ]
               if ! Empty( ::aStruct[ nCol ][ DBS_PIC ] )
                  :cEditPicture  := ::aStruct[ nCol ][ DBS_PIC ]
               endif
               if lAutoSort
                  :cSortOrder := ::aStruct[ nCol ][ DBS_TAG ]
               endif
            else
               :bEditValue := { |x| If( x != nil, oSend( oBrw:oDbf, "_" + cCol, x ), ), OSend( oBrw:oDbf, cCol ) }
            endif
            :bOnPostEdit     := { |o,x,n| If( n != VK_ESCAPE, o:Value := x, ) }
         END
      next
   endif

return oBrw

//----------------------------------------------------------------------------//
METHOD _xBrowse( oWnd, cTitle, aCols, lAutoSort, bSetUp ) CLASS TDataBase

   local oBrw

   DEFAULT cTitle := ::cFile, lAutoSort := .t.

   if ownd == nil
      XBrowse( Self, cTitle, lAutoSort, bSetUp, aCols )
   elseif oWnd:IsKindOf( 'TXBROWSE' )
      oBrw     := oWnd
      ::SetXBrowse( oBrw, aCols, lAutoSort )
      if bSetUp != nil
         if bSetUp == .t.
            oWnd:bValid := { ||oBrw:oDbf:Close(),.t. }
         else
            Eval( bSetUp, oBrw )
         endif
      endif
   elseif oWnd:IsKindOf( 'TWINDOW' )
      if oWnd:IsKindOf( 'TMDIFRAME' )
         define window oWnd /* mdichild */ title cTitle
      endif
      oBrw     := TXBrows():New( oWnd )
      ::SetXBrowse( oBrw, aCols, lAutoSort )
      if bSetUp != nil
         if bSetUp == .t.
            oWnd:bValid := { ||oBrw:oDbf:Close(),.t. }
         else
            Eval( bSetUp, oBrw )
         endif
      endif
      oBrw:CreateFromCode()
      if !( oWnd:isKindOf( 'TDIALOG' ) .and. ValType( bSetUp ) == 'B' )
         oWnd:oClient := oBrw
      endif
      if oWnd:IsKindOf( 'TDIALOG' )
         activate dialog oWnd
      else
         activate window oWnd
      endif
   endif

return oBrw
//----------------------------------------------------------------------------//

#endif

//----------------------------------------------------------------------------//

function OrderTagInfo( aStruct, nCol )

   local nFor, nAt, i, nOrders, aTokens, lCond, aCond, aPos

   DEFAULT aStruct      := DbStruct(), ;
           nCol         := DBS_TAG

   aCond       := Array( Len( aStruct ) ); AFill( aCond, .f. )
   aPos        := Array( Len( aStruct ) ); AFill( aPos,   0  )

   for nFor := 1 to Len( aStruct )
      if Len( aStruct[ nFor ] ) < nCol
         ASize( aStruct[ nFor ], nCol )
      endif
   next nFor

   nOrders     := OrdCount()
   for nFor := 1 to nOrders

      lCond    := ! Empty( OrdFor() )

      aTokens  := GetTokens( OrdKey( nFor ) )
      for i := 1 to Len( aTokens )
         nAt   := AScan( aStruct, { |aFld| aFld[ 1 ] == aTokens[ i ] } )
         if nAt > 0
            if aStruct[ nAt ][ nCol ] == nil .or. ( aCond[ nAt ] .and. ! lCond ) .or. ;
                                                  ( aPos[  nAt ] > i )
               aStruct[ nAt ][ nCol ] := Upper( OrdName( nFor ) )
               aCond[ nAt ]   := lCond
               aPos[  nAt ]   := i
            endif
            EXIT
         endif
      next i

   next nFor

return aStruct

//----------------------------------------------------------------------------//

static function GetTokens( cStr )

   local aTokens  := {}
   local n,c,sep

   cStr  := Upper( cStr )
   cStr  := StrTran( StrTran( cStr, "->", '!' ), '=', ' ' )
   for n := 1 to 10
      c  := Token( cStr, nil, n, nil, nil, @sep )
      if Empty( c )
         exit
      endif
      if sep != '!' .and. sep != '('
         AAdd( aTokens, c )
      endif
   next

return aTokens

//----------------------------------------------------------------------------//

function FieldInExpr( cStr, aStruct )

   local cFld  := ""
   local aTokens  := GetTokens( cStr )
   local cToken

   DEFAULT aStruct   := DbStruct()
   FOR EACH cToken IN aTokens
      cToken   := Upper( cToken )
      if AScan( aStruct, { |a| a[ 1 ] == cToken } ) > 0
         cFld  := cToken
         EXIT
      endif
   NEXT

return cFld

//----------------------------------------------------------------------------//

function FW_DbfToArray( cFieldList, bFor, bWhile, nNext, nRec, lRest )

   local aRet  := {}, nRecNo := RecNo(), bLine

   // cFieldList : comma delimited list of fields. Eg: "First,City,Age"

   if Empty( cFieldList )
      cFieldList  := ""
      AEval( DbStruct(), { |a| cFieldList += "," + a[ 1 ] } )
      cFieldList  := Substr( cFieldList, 2 )
   endif

   bLine    := &( "{||{" + cFieldList + "}}" )
   DbEval( { || AAdd( aRet, Eval( bLine ) ) }, bFor, bWhile, nNext, nRec, lRest )
   DBGOTO( nRecNo )

return aRet

//----------------------------------------------------------------------------//

function FW_RecToHash( cFieldList, cNames )

   local hRec     := {=>}
   local aVals, aNames

   HSetCaseMatch( hRec, .f. )

   if Empty( cFieldList )
      cFieldList  := ""
      AEval( DbStruct(), { |a| cFieldList += "," + a[ 1 ] } )
      cFieldList  := Substr( cFieldList, 2 )
   endif
   DEFAULT cNames    := cFieldList
   aNames            := HB_ATokens( cNames, ',' )

   aVals    := &( '{' + cFieldList + '}' )
   AEval( aVals, { |u,i| hSet( hRec, aNames[ i ], u ) },, Len( aNames ) )

return hRec

//----------------------------------------------------------------------------//

function FW_HashToRec( hRec, cFieldList )

   local lShared  := DbInfo( DBI_SHARED )
   local lLocked  := .f.
   local lSaved   := .f.
   local aFlds

   if ! lShared .or. ;
      ( DbInfo( DBI_ISFLOCK ) .or. DbRecordInfo( DBRI_LOCKED, RecNo() ) ) .or. ;
      ( lLocked   := DbrLock( RecNo() ) )

      if Empty( cFieldList )
         HEval( hRec, { |k,v,i| FieldPut( FieldPos( k ), v ) } )
      else
         aFlds    := HB_ATokens( cFieldList, ',' )
         HEval( hRec, { |k,v,i| FieldPut( FieldPos( aFlds[ i ] ), v ) },, Len( aFlds ) )
      endif

      if lLocked
         DbRUnlock( RecNo() )
      endif
      lSaved      := .t.

   endif

return lSaved

//----------------------------------------------------------------------------//

function FW_DbfToExcel( cFieldList, bFor, bWhile, nNext, nRec, lRest )

   local nRecNo := RecNo(), bLine
   local oExcel, oBook, oSheet, oRange, aHead
   local nCols, nRow

   // cFieldList : comma delimited list of fields. Eg: "First,City,Age"

   if Empty( cFieldList )
      cFieldList  := ""
      AEval( DbStruct(), { |a| cFieldList += "," + a[ 1 ] } )
      cFieldList  := Substr( cFieldList, 2 )
   endif
   aHead    := HB_ATokens( cFieldList, "," )
   nCols    := Len( aHead )

   bLine    := &( "{||{" + cFieldList + "}}" )
   if Empty( bWhile ) .and. Empty( nNext ) .and. Empty( nRec ) .and. Empty( lRest )
      GO TOP
   endif

   oExcel   := ExcelObj()
   if oExcel == nil
      MsgAlert( "Excel not installed" )
      return nil
   endif
   oBook    := oExcel:WorkBooks:Add()
   oSheet   := oBook:ActiveSheet
   oRange   := oSheet:Range( oSheet:Columns( 1 ), oSheet:Columns( nCols ) )
   oExcel:ScreenUpdating   := .f.

   oRange:Rows( 1 ):Value  := aHead
   nRow     := 2

   DbEval( { || oRange:Rows( nRow ):Value := Eval( bLine ), nRow++ }, bFor, bWhile, nNext, nRec, lRest )
   DBGOTO( nRecNo )

   oRange:Rows( 1 ):Font:Bold   := .t.
   oRange:AutoFit()
   oExcel:ScreenUpdating   := .t.
   oExcel:visible          := .t.

return nil

//----------------------------------------------------------------------------//

