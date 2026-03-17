             PGM
             /** C$$TST  *********************************************/
             /*  TEST CLP FOR VS CODE                                */
             /*  J.WATANABE 2025.07.03       X                       */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
        /**  CALL       PGM(HOBJ1/CHKR51 ) PARM(&RTN)    **/
             CALL       PGM(HOBJ1/CHKR51A) PARM(&RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             CRTDUPOBJ  OBJ(PRT132A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT132A)
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132A)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((ProductionControl@iafi.com) +
                          (JONATHON.JULSON@IAFI.COM)) DSTD('SEND +
                          ASN ASAP') MSG('PRODUCTION CONTROL, +
                          PLEASE SEND ASN AS SOON AS POSSIBLE. +
                          (CHKC51A).') DOCFILE(QTEMP/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) +
                          DOCD('MISSING ASN')
             DLTOVR     FILE(PRT132)
             ENDDO


             ENDPGM
