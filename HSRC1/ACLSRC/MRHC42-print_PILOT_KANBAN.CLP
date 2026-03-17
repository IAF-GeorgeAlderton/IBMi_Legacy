             PGM        PARM(&P@KKBN)
             /*** MRHC42 ***********************************/
             /*試作かんばん発行　データ転送              */
             /*  TR-ITS            2014.02.06              */
             /**********************************************/

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             DCL        VAR(&MRHWP61) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)     TYPE(*CHAR) LEN(3)

             DCL        VAR(&P@KKBN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&MRHWP61) VALUE('MRHWP61' *CAT &WS3)

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
             RTVOBJD    OBJ(MRHPP61) OBJTYPE(*FILE) RTNLIB(&MLIB)

             CLRPFM     (&MLIB/MRHPP61)
 #STP10:
        /*試作かんばん発行　通常発行　              */
             IF         COND(&P@KKBN *EQ '1') THEN(DO)
             CALL       PGM(MRHR42)
             ENDDO
 #STP20:
        /*試作かんばん発行　再発行　　              */
             IF         COND(&P@KKBN *EQ '2') THEN(DO)
             CALL       PGM(MRHR43)
             ENDDO
 #STP30:
        /*データ転送　　　　　　　　　　            */

 END:
             ENDPGM
