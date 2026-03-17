             PGM
             /** AC#C22 *****************************************************/
             /*  (HONDA) DETECT DUPLICATE ORDER WITH DIFFERENT BIN# (PP2A)  */
             /*  J.WATANABE 2019.03.08                                      */
             /*  &UPD: "Y" --> DELETE ORDER                                 */
             /***************************************************************/

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR )  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&UPD )  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CHGVAR     VAR(&UPD) VALUE('Y')

             OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1)
             CALL       PGM(AC#R2C) PARM(&UPD &RTN)

             IF         COND(&RTN *NE '*') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)

             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)

             CALL       PGM(HOBJ1/AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET(('KAZ.WATANABE@iafi.com')) +
                          DSTD('HONDA Detect Duplicate Order') +
                          MSG('DETECT DUPLICATE ORDER WITH +
                          DIFFERENT BIN# !!!') +
                          DOCFILE(HWFILE1/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('HONDA DETECT DUPLICATE ORDER')
             DLTOVR     FILE(PRT132)
             ENDDO

             ENDPGM
