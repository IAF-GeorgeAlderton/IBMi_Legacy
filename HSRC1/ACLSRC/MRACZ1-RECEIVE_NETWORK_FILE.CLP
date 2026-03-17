             PGM       PARM(&LOCATION &PC_SYS)
             /** MRACZ1 **************************************/
             /* RECEIVE NETWORK FILE                         */
             /*    TRANCOM ITS.        2012.10.05            */
             /************************************************/
             DCL        VAR(&LOCATION) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PC_SYS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&MBAN)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&WS)       TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSNO)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PMSG) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&WNBR) TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&WNBR)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3)   VALUE(%SST(&WSID 1 3))

             CALL       PGM(MRACZ3) PARM(&USER &WNBR &LOCATION &PC_SYS)

 @DLY1:
             DLYJOB     DLY(10)

 STP00:
             WRKNETF    USER(*ALL) OUTPUT(*OUTFILE) +
                          OUTFILE(HWFILE1/MRAWPZ1)

             RTVMBRD    FILE(HWFILE1/MRAWPZ1) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(@DLY))
 STP01:
         /* MRAWPZ1 ---> MRAPPZ1 */
             CALL       PGM(MRARZ1)
 STP02:
         /* MRAPPZ1 ---> RCVNETF ---> CALL PGM */
             CALL       PGM(MRARZ2)
 @DLY:
             GOTO       CMDLBL(@DLY1)
 END:
             ENDPGM
