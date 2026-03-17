             PGM
             /** AFACP1 **********************************/
             /* KANBAN DISPATCH SUB .SYSTEM . (1)..      */
             /* I-HASADA                 89.07.24        */
             /* N-HYOTO  2001.04.23 CHANGE ISSSUE 8 ->12 */
             /********************************** AFACP1 **/
             DCLF       FILE(AFAPW10)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PTIM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RQS) TYPE(*CHAR) LEN(80)
             DCL        VAR(&PCK1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCK2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSTS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCHK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)

             DCL        VAR(&PHS) TYPE(*CHAR) LEN(4)
             DCL        VAR(&HSRC1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             RTVJOBA    JOB(&WSID) USER(&USER) DATE(&DATE)

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
 STPINI:
             CALL       PGM(AAIR91) PARM(&PCHK)
             IF         (&PCHK *EQ '9') DO
             CHGVAR     VAR(&MSGTXT) VALUE('CAN NOT EXEC BEFORE +
                          00:00 (G)')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &PKOUT)
             GOTO       CMDLBL(END)
             ENDDO


             CHKOBJ     OBJ(AFAACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STPX))
             CHGVAR     VAR(&IN03) VALUE('1')

 STPX:       CHGVAR     VAR(&JKAN) VALUE('0000')

             CALL       PGM(AFARBB) PARM('A' &PCK1)
             IF         (&PCK1 *EQ '0') DO
             CHGVAR     VAR(&IN98) VALUE('1')
             ENDDO

             CALL       PGM(AFARBB) PARM('B' &PCK2)
             IF         (&PCK2 *EQ '1') DO
      /*     CHGVAR     VAR(&JKAN) VALUE('0900')   */
             ENDDO

             CHGVAR     VAR(&PTIM) VALUE(%SST(&TIME 1 2))
         /*  IF         COND((&PTIM *EQ '22') *OR (&PTIM *EQ '23') +
                          *OR (&PTIM *EQ '00')) THEN(DO)              */
             CHGVAR     VAR(&IN04) VALUE('1')
         /*  ENDDO                                                    */

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AFAPW101)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') DO
             GOTO       END
             ENDDO

       /*    IF         (&IN11 *EQ '1') DO                        */
       /*    WRKACTJOB                                            */

       /*    CHGVAR     VAR(&IN03) VALUE('0')                     */
       /*    CHKOBJ     OBJ(AFAACT) OBJTYPE(*DTAARA)              */
       /*    MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))    */
       /*    CHGVAR     VAR(&IN03) VALUE('1')                     */
       /*    GOTO       STP1                                      */
       /*    ENDDO                                                */

       /*    IF         (&IN12 *EQ '1') DO                        */
       /*    DLTDTAARA  DTAARA(AFAACT)                            */
       /*    MONMSG     MSGID(CPF2105)                            */

       /*    CHGVAR     VAR(&IN03) VALUE('0')                     */
       /*    GOTO       STP1                                      */
       /*    ENDDO                                                */

             IF         (&IN24 *EQ '1') DO
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             GOTO       STP1
             ENDDO

             IF         (%SUBSTRING(&JKAN 1 2) *GE '24') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT TIME FROM OOOO TO 2300.')
             GOTO       STP1
             ENDDO

             IF         (%SUBSTRING(&JKAN 3 2) *NE '00') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('TIME CAN APPOINT ONLY 00 MINUTES+
                          .')
             GOTO       STP1
             ENDDO

             IF         (&PCK1 *EQ '0') DO
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('THIS SYSTEM CAN NOT BE EXECUTED+
                          .')
             GOTO       STP1
             ENDDO

             IF         COND(&JKAN *EQ '0000') THEN(DO)
             CHGVAR     VAR(&PSTS) VALUE(' ')
             CALL       PGM(AFAR01) PARM(&PSTS)
             IF         COND(&PSTS *EQ 'NG') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('A-PICS DATA CREATION OR +
                          RECEPTION IS NOT COMPLETED.')
             GOTO       CMDLBL(STP1)
             ENDDO
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1

             CHGVAR     VAR(&IN03) VALUE('0')
             CHKOBJ     OBJ(AFAACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STPY))
             CHGVAR     VAR(&IN03) VALUE('1')
             GOTO       STP1

 STPY:       CRTDTAARA  DTAARA(AFAACT) TYPE(*CHAR) LEN(10) +
                          TEXT('A-PICS 1 PRODUCTION INSTRUCTION +
                          DATA MAKING') AUT(*ALL)

             CHGVAR     VAR(&PHS) VALUE(&JKAN)
             CHGVAR     VAR(&HSRC1) VALUE('HSRC1     ')
             CHGVAR     VAR(&PDEVT) VALUE('*SCS  ')
             CHGVAR     VAR(&PIGCD) VALUE('*YES')

             IF         COND(&JKAN *EQ '0000') THEN(DO)
             CHGVAR     VAR(&JKAN) VALUE('2400')
             ENDDO

             CHGVAR     VAR(&OUTQ) VALUE(&PRTG)
             IF         (&TYPE *EQ 'K') DO
             CHGVAR     VAR(&OUTQ) VALUE(&PRT)
             ENDDO

             CHGVAR     VAR(&RQS) VALUE('CALL AFACJ1 (''' *CAT &USER +
                          *CAT ''' ''' *CAT &WSID *CAT ''' ''' *CAT +
                          &OUTQ *CAT ''' ''' *CAT &JKAN *CAT ''')')

         /* GET BACKUP DATA FOR A-PICS TEST */
             CALL       PGM(AFACBK)

             SBMJOB     JOB(APICS1) JOBD(QBATCH3) JOBQ(JOBQ3) +
                          RQSDTA(&RQS)

             IF         (&JKAN *EQ '2400') DO
             CALL       PGM(ACEC01) /* 材料マスターデータ作成 */
             ENDDO

          /* CALL       PGM(CAACJ1) PARM(&WSID &USER &PHS &HSRC1 +
                          &PLIB &WLIB &PDEVT &PIGCD &PRTG) */

             SBMJOB     CMD(CALL PGM(CAACJ1) PARM(&WSID &USER &PHS +
                          &HSRC1 &PLIB &WLIB &PDEVT +
                          &PIGCD &PRTG)) JOB(APICS2) JOBD(QBATCH3) +
                          JOBQ(JOBQ3)

 END:        ENDPGM
