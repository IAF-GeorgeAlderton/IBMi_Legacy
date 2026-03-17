         PGM
         /** MBDCP7 *****************************************/
         /*  SALES DATA STATISTICS FOR PC (OUTPUT TO IFS)   */
         /*  W.WATANABE            2019.04.26               */
         /***************************************************/
             DCL        VAR(&REC)   TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYS)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FNAM) TYPE(*CHAR)  LEN(30)
 RUN:
             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WS) USER(&USER)

             CHGVAR     VAR(&FNAM) VALUE('SHIPPING RESULT FOR PC')

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CRTDUPOBJ  OBJ(MBDWPP7) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/MBDWPP7)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)

      /* CREATE MBDWPP7 (WORK FILE) */
             OVRDBF     FILE(MBDWPP7) TOFILE(QTEMP/MBDWPP7)
             CALL       PGM(MBDRP7)

             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)

             RTVMBRD    FILE(QTEMP/MBDWPP7) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(#END))

      /* TRANSFER.....*/
             CALL       PGM(APLC97) PARM('2' 'MBDWPP7' 'QTEMP' +
                          &FNAM 'Y' ' ' 'Y')
 #END:
             DLTOVR     FILE(*ALL)
             ENDPGM
