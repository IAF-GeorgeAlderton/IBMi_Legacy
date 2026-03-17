             PGM
             /** CHKC61 **********************************************/
             /*  CHECK FORD ORDERS                                   */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)         */
             /*  ADD JOB TO FCKC03  (JOB SCHEDULE: 07:33 AM)         */
             /*  ADD JOB TO FCKC04  (JOB SCHEDULE: 17:00 PM SUNDAY)  */
             /*  J.WATANABE 2020.07.29                               */
             /********************************************************/

             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1) VALUE('Y')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&SIGN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAYS) TYPE(*CHAR) LEN(4)
             DCL        VAR(&IAF)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&TGT ) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/* GET TODAY */
             CHGVAR     VAR(&SRC ) VALUE(' ')
             CALL       PGM(UTLR01) PARM(&SRC &DATE &RTN)

/* GET TOMORROW */
             CHGVAR     VAR(&SIGN) VALUE('+')
             CHGVAR     VAR(&DAYS) VALUE('0001')
             CHGVAR     VAR(&IAF ) VALUE('Y')
             CALL       PGM(UTLR10) PARM(&DATE &SIGN &DAYS &IAF &TGT &RTN)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) LPI(6) +
                          OVRFLW(62) OUTQ(LANPRT03) HOLD(*YES) +
                          SAVE(*YES) USRDTA('FORD-ADD')

             CALL       PGM(AB#R0E3B) PARM(&TGT &DATE 'Y')

             CRTDUPOBJ  OBJ(PRT198 ) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT198 )
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT198) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT198) TOFILE(QTEMP/PRT198 )
             CALL       PGM(AB#RW1)

             IF         COND(&USER = 'I0777') THEN(DO)
             SNDDST     TYPE(*FILE) TOINTNET((kaz.watanabe@iafi.com) +
                          ('larry.cox@iafi,com')) DSTD('FORD ADD-ON +
                          ORDER CHECK LIST') MSG('** Note ** FORD +
                          ADD-ON ORDER CHECK LIST. (CHKC61).') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('FORD ADD-ON ORDER +
                          CHECK LIST')
             GOTO       CMDLBL(ENDP)
             ENDDO

             SNDDST     TYPE(*FILE) +
                          TOINTNET((ProductionControl@iafi.com) +
                          (jonathon.julson@iafi.com)) DSTD('FORD +
                          ADD-ON ORDER CHECK LIST') MSG('** Note ** +
                          FORD ADD-ON ORDER CHECK LIST. (CHKC61).') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('FORD ADD-ON ORDER +
                          CHECK LIST')

 ENDP:
             DLTOVR     FILE(PRT198)
             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             ENDPGM
