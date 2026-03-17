             PGM
             /*** MRHC99 ***********************************/
             /*絶対№管理ファイル　コンバート            */
             /*  TR-ITS            2014.01.20              */
             /**********************************************/
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(10)

             RTVOBJD    OBJ(MRHPP41) OBJTYPE(*FILE) RTNLIB(&FLIB)

 #STP10:
             CLRPFM     (&FLIB/MRHPP41)
             CALL       PGM(MRHR99)

 END:
             ENDPGM
