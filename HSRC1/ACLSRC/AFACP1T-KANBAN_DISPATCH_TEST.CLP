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
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             RTVJOBA    JOB(&WSID) USER(&USER) DATE(&DATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHKOBJ     OBJ(TFILE1/AFAACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STPX))
             CHGVAR     VAR(&IN03) VALUE('1')

 STPX:       CHGVAR     VAR(&JKAN) VALUE('0800')

             CALL       PGM(AFARBB) PARM('A' &PCK1)
             IF         (&PCK1 *EQ '0') DO
             CHGVAR     VAR(&IN98) VALUE('1')
             ENDDO

             CALL       PGM(AFARBB) PARM('B' &PCK2)
             IF         (&PCK2 *EQ '1') DO
      /*     CHGVAR     VAR(&JKAN) VALUE('0900')   */
             ENDDO

             CHGVAR     VAR(&PTIM) VALUE(%SST(&TIME 1 2))
             IF         ((&PTIM *GE '06') *AND (&PTIM *LE '08')) DO
             CHGVAR     VAR(&IN04) VALUE('1')
             ENDDO

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AFAPW101)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') DO
             GOTO       END
             ENDDO

             IF         (&IN11 *EQ '1') DO
             WRKACTJOB

             CHGVAR     VAR(&IN03) VALUE('0')
             CHKOBJ     OBJ(TFILE1/AFAACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))
             CHGVAR     VAR(&IN03) VALUE('1')
             GOTO       STP1
             ENDDO

             IF         (&IN12 *EQ '1') DO
             DLTDTAARA  DTAARA(TFILE1/AFAACT)
             MONMSG     MSGID(CPF2105)

             CHGVAR     VAR(&IN03) VALUE('0')
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

             IF         (&IN05 *EQ '0') GOTO STP1

             CHGVAR     VAR(&IN03) VALUE('0')
             CHKOBJ     OBJ(TFILE1/AFAACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STPY))
             CHGVAR     VAR(&IN03) VALUE('1')
             GOTO       STP1

 STPY:       CRTDTAARA  DTAARA(TFILE1/AFAACT) TYPE(*CHAR) LEN(10) +
                          TEXT('A-PICS 1 PRODUCTION INSTRUCTION +
                          DATA MAKING') AUT(*ALL)

             CHGVAR     VAR(&OUTQ) VALUE(&PRTG)
             IF         (&TYPE *EQ 'K') DO
             CHGVAR     VAR(&OUTQ) VALUE(&PRT)
             ENDDO

  /* TEST PGM  */
             CHGVAR     VAR(&RQS) VALUE('CALL AFACJ1T (''' *CAT +
                          &USER *CAT ''' ''' *CAT &WSID *CAT ''' +
                          ''' *CAT &OUTQ *CAT ''' ''' *CAT &JKAN +
                          *CAT ''')')

             SBMJOB     JOB(APICS1T) JOBD(QBATCH4) JOBQ(JOBQ4) +
                          RQSDTA(&RQS)

             IF         (&JKAN *EQ '0800') DO
             CALL       PGM(ACEC01) /* 材料マスターデータ作成 */
             ENDDO

 END:        ENDPGM
