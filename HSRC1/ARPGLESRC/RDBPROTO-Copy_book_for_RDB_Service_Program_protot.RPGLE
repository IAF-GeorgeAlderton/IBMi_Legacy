
           //Blob return Data Structure
     D*retBlobDS       DS                  qualified template inz
     D* blobdata1               8386551A
     D RdbConnect      PR            10I 0
     D  peConnID                     10A   Const
     D  peUser                       40A   Const Options(*Nopass)
     D  pePass                       40A   Const Options(*Nopass)
     D  pePort                        4S 0 Const Options(*Nopass)

     D RdbClose        PR
     D  peSockID                     10I 0

     D RdbFreeStmt     PR
     D  peSockID                     10I 0

     D RdbExec         PR            10I 0
     D  peSockID                     10I 0
     D  peStmt                    32767A   CONST Varying Options(*Varsize)
     D  peUpdate                       N   Const Options(*Nopass)

     D RdbPrepStmt     PR            10I 0
     D  peSockID                     10I 0
     D  peStmt                    32767A   CONST Varying Options(*Varsize)
     D  peUpdate                       N   Const Options(*Nopass)

     D RdbPrepExec     PR            10I 0
     D  peSockID                     10I 0

     D RdbFetchNxt     PR            10I 0
     D  peSockID                     10I 0

     D RdbFetchPrv     PR            10I 0
     D  peSockID                     10I 0

     D RdbFetchAbs     PR            10I 0
     D  peSockID                     10I 0
     D  peRec#                       10I 0 Const

     D RdbSetNum       PR            10I 0
     D  peSockID                     10I 0
     D  peFld#                       10I 0 Const
     D  peNum                        30S 9 Const

     D RdbSetStr       PR            10I 0
     D  peSockID                     10I 0
     D  peFld#                       10I 0 Const
     D  peStr                     32767A   CONST Varying Options(*Varsize)

     D RdbSetDate      PR            10I 0
     D  peSockID                     10I 0
     D  peFld#                       10I 0 Const
     D  peDate                         Z   Const

     D RdbSetNull      PR            10I 0
     D  peSockID                     10I 0
     D  peFld#                       10I 0 Const
     D  peType                       10I 0 Const

     D RdbGetNum       PR            30S 9
     D  peSockID                     10I 0
     D  peFld#                       10I 0 Const

     D RdbGetStr       PR         32767A   Varying
     D  peSockID                     10I 0
     D  peFld#                       10I 0 Const

     D RdbGetDate      PR              Z
     D  peSockID                     10I 0
     D  peFld#                       10I 0 Const

     D RdbAscNum       PR            30S 9
     D  peSockID                     10I 0
     D  peFldName                    50A   Const

     D RdbAscStr       PR         32767A   Varying
     D  peSockID                     10I 0
     D  peFldName                    50A   Const

     D RdbAscDate      PR              Z
     D  peSockID                     10I 0
     D  peFldName                    50A   Const

     D RdbGetData      PR         32766A
     D  peSockID                     10I 0
     *
     D RdbError        PR
     D  peError                       7A
     D  peErrText                   100A

     D RdbSetCommit    PR            10I 0
     D  peSockID                     10I 0
     D  peTrue                         N   Const

     D RdbCommit       PR            10I 0
     D  peSockID                     10I 0

     D RdbRollback     PR            10I 0
     D  peSockID                     10I 0

     D RdbAddRec       PR            10I 0
     D  peSockID                     10I 0
     D  peData                    32766A   CONST Varying Options(*Varsize)

     D RdbUpdRec       PR            10I 0
     D  peSockID                     10I 0
     D  peData                    32766A   CONST Varying Options(*Varsize)

     D RdbDelRec       PR            10I 0
     D  peSockID                     10I 0

     D RdbNextSet      PR            10I 0
     D  peSockID                     10I 0

     D Rdb_Array       S             10I 0 Inz(2003)
     D Rdb_Boolean     S             10I 0 Inz(16)
     D Rdb_Char        S             10I 0 Inz(1)
     D Rdb_Clob        S             10I 0 Inz(2005)
     D Rdb_Date        S             10I 0 Inz(91)
     D Rdb_Decimal     S             10I 0 Inz(3)
     D Rdb_Double      S             10I 0 Inz(8)
     D Rdb_Float       S             10I 0 Inz(6)
     D Rdb_Integer     S             10I 0 Inz(4)
     D Rdb_Null        S             10I 0 Inz(0)
     D Rdb_Numeric     S             10I 0 Inz(2)
     D Rdb_Real        S             10I 0 Inz(7)
     D Rdb_SmallInt    S             10I 0 Inz(5)
     D Rdb_Time        S             10I 0 Inz(92)
     D Rdb_TimeStamp   S             10I 0 Inz(93)
     D Rdb_VarChar     S             10I 0 Inz(12)

     D RdbRegOutput    PR            10I 0
     D  peSockID                     10I 0
     D  peFld#                       10I 0 Const
     D  peType                       10I 0 Const
     D  peScale                      10I 0 Const

     D RdbGetParmNum   PR            30S 9
     D  peSockID                     10I 0
     D  peFld#                       10I 0 Const

     D RdbGetParmStr   PR         32767A   Varying
     D  peSockID                     10I 0
     D  peFld#                       10I 0 Const

     D RdbGetParmDate  PR              Z
     D  peSockID                     10I 0
     D  peFld#                       10I 0 Const

     D RdbStoredProc   PR            10I 0
     D  peSockID                     10I 0
     D  peStmt                    32767A   CONST Varying Options(*Varsize)

     D RdbTrace        PR            10I 0
     D  peSockID                     10I 0
     D  peTrace                        N   Const

v40  D RdbCrtTable     PR            10I 0
v40  D  peSockID                     10I 0
v40  D  peTable                    4096A   Const
v40
v40  D RdbSetIsoDate   PR            10I 0
v40  D peSockId                      10I 0
v40  D peFld#                        10I 0 Const
v40  D peIsoDate                       D   Const

v40  D RdbHelpOpt      PR              n
v40  D  Start                         2S 0 Const
v40  D  End                           2S 0 Const

v42  D RdbSetIsoTime   PR            10I 0
v42  D peSockId                      10I 0
v42  D peFld#                        10I 0 Const
v42  D peIsoTime                       T   Const

v42  D RdbGetCatlg     PR            10I 0
v42  D  peSockID                     10I 0
v42  D  peStruct                       *

v42  D RdbSetCharStr   PR            10I 0
v42  D peSockId                      10I 0
v42  D peFldnum                      10I 0 Const
v42  D peCharStream               32767A   Const

v42  D RdbGetCharStr   PR         32767A   Varying
v42  D  peSockID                     10I 0
v42  D  peFld#                       10I 0 Const
       //Get Iso Date
v42c D RdbGetIsoDate   PR              D
v42c D  peSockID                     10I 0
v42c D  peFld#                       10I 0 Const
v42d  * Send Alert to specific user in DTAARA (RDBUSERMSG)
v42d D RdbSndErrAlert  PR              N
v42d D piAlrtOnOFf                    1A   const Options(*nopass)
       //Get Iso Time
v42c D RdbGetIsoTime   PR              T
v42c D  peSockID                     10I 0
v42c D  peFld#                       10I 0 Const
      * Get ISO Time from remote database by field name
     D RdbAscIsoTime   PR              T
     D  peSockID                     10I 0
     D  peFldName                    50A   Const

      * Get ISO Time from remote database by field name
     D RdbAscIsoDate   PR              D
     D  peSockID                     10I 0
     D  peFldName                    50A   Const

      * Set Integer Value
     D RdbSetInt       PR            10I 0
     D  Id                           10I 0
     D  peFld#                       10I 0 Const
     D  peInteger                    10S 0 Const

      * Set a Negative Integer Value
     D RdbSetNegInt    PR            10I 0
     D  Id                           10I 0
     D  peFld#                       10I 0 Const
     D  peInteger                    11S 0 Const
