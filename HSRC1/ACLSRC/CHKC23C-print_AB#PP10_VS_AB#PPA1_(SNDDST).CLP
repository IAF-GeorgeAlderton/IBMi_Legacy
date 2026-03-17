             PGM
             /** CHKC24 **********************************************/
             /*  CHECK INCORRECT AB#PPA1                             */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)         */
             /*  CALL    PGM(WATALIB/@AB#PPA2 )  OLD                 */
             /*  CALL    PGM(HOBJ1  /CHKRA1   )  NEW                 */
             /*  J.WATANABE 10/13/2017                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
  /**OLD     CALL       PGM(WATALIB/@AB#PPA2 ) PARM('20200101' &RTN) ***/

             CALL       PGM(HOBJ1/CHKRA1A    ) PARM('20210101' &RTN)
             CALL       PGM(HOBJ1/CHKRA1     ) PARM('20210101' &RTN)

             IF         (&RTN *NE ' ') THEN(DO)
             CRTDUPOBJ  OBJ(PRT132A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT132A)
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132A)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('*** Incorrect AB#PPA1 found ***') +
                          MSG('*** Incorrect AB#PPA1 has been found *** +
                          Please fix it to prevent from future +
                          issue. (CHKC24).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('*** INCORRECT AB#PPA1 LIST***')
             DLTOVR     FILE(PRT132)
             ENDDO


             ENDPGM
