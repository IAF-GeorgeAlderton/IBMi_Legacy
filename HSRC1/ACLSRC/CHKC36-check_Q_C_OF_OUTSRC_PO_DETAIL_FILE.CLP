             PGM
             /** CHKC36 *****************************************/
             /*  CHECK Q/C OF OUTSRC PO DETAIL FILE (AFDPP10)   */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM)    */
             /*  J.WATANABE 2018.10.05                          */
             /***************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             DCL        VAR(&DATE6) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE8) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SIGN ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAYS ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&IAF  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TGT8 ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DATE6)
             CHGVAR     VAR(&DATE8) VALUE('20' *CAT &DATE6)
             CHGVAR     VAR(&SIGN ) VALUE('-')
             CHGVAR     VAR(&IAF  ) VALUE('N')
             CHGVAR     VAR(&TGT8 ) VALUE('        ')
             CHGVAR     VAR(&RTN  ) VALUE(' ')

 /* TARGET 3 DAYS ---------------------------------------------------------*/
             CHGVAR     VAR(&DAYS ) VALUE('0003')
             CALL       PGM(UTLR10) PARM(&DATE8 &SIGN &DAYS &IAF &TGT8 &RTN)

             CALL       PGM(CHKR36) PARM(&TGT8 '99999999' &RTN)

             IF         (&RTN *NE ' ') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('ERROR Q/C in OUTSRC DETAIL +
                          (AFDPP10)') MSG('** ERROR ** INCORRECT +
                          Q/C OF OUTSRC PO DETAIL FILE +
                          (AFDPP10).(CHKC36).') +
                          DOCFILE(HWFILE1/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('INCORRECT Q/C IN +
                          OUTSRC PO')
             DLTOVR     FILE(PRT132)
             ENDDO


 END:        ENDPGM
