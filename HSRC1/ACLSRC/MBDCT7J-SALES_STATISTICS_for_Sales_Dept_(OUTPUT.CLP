         PGM
         /** MBDCT6 *****************************************/
         /* SALES DATA STATISTICS (OUTPUT TO IFS) NEW       */
         /*  W.WATANABE            2017.08.29               */
         /* -----------------------------------             */
         /*  JW1  ADD MBDWPT6 FOR 5 YEAR REPORT             */
         /***************************************************/
             DCL        VAR(&REC)   TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
 RUN:
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 /* JW1 FOR MBDWPT5 */
             CRTDUPOBJ  OBJ(MBDWPT5) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/MBDWPT5)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)

 /* JW1 FOR MBDWPT6 */
             CRTDUPOBJ  OBJ(MBDWPT6) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/MBDWPT6)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)

             OVRDBF     FILE(MBDWPT5) TOFILE(QTEMP/MBDWPT5)
             OVRDBF     FILE(MBDWPT6) TOFILE(QTEMP/MBDWPT6)

             CALL       PGM(MBDRT7)

 /* JW1 OUTPUT MBDWPT5 */
             RTVMBRD    FILE(QTEMP/MBDWPT5) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             /* TRANSFER ISF.CSV */
             CALL       PGM(APLC94) PARM('2' 'MBDWPT5   ' 'QTEMP     +
                          ' 'SALES DATA STATISTICS         ' 'Y' ' +
                          ' 'Y')
             GOTO #END
             ENDDO

 /* JW1 OUTPUT MBDWPT6 5 YEAR REPORT */
             RTVMBRD    FILE(QTEMP/MBDWPT6) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             /* TRANSFER ISF.CSV */
             CALL       PGM(APLC94) PARM('2' 'MBDWPT6   ' 'QTEMP     +
                          ' 'SALES DATA STATISTICS 5 YEARS ' 'Y' ' +
                          ' 'Y')
             GOTO #END
             ENDDO

 #END:
             DLTOVR     FILE(*ALL)
             ENDPGM
