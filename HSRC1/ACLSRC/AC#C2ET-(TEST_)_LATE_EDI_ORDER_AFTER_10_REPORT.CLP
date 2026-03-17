             PGM
             /** AC#C2FT *********************************************/
             /*  HONDA LATE EDI ORDER AFTER 10:05 REPORT             */
             /*  J.WATANABE 2022.01.03                               */
             /********************************************************/

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR )  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&UPD )  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1)
             CALL       PGM(HOBJ1/AC#R2E2) PARM(&RTN)

             CRTDUPOBJ  OBJ(PRT132A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/PRT132A

             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)

             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132A)

             CALL       PGM(HOBJ1/AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET(('KAZ.WATANABE@iafi.com')) +
                          DSTD('HONDA EDI LATE ORDER AFTER 10:05') +
                          MSG('HONDA LATE EDI ORDER AFTER 10:05    +
                          REPORT. (AC#C2E).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('HONDA LATE EDI ORDER +
                          AFTER 10:05 REPORT')

       /*    SNDDST     TYPE(*FILE) +
       /*                 TOINTNET(('ProductionControl@iafi.com')) +  */
       /*                 DSTD('HONDA EDI LATE ORDER AFTER 10')    +  */
       /*                 MSG('HONDA LATE EDI ORDER AFTER 10       +  */
       /*                 REPORT. (AC#C2E).')                      +  */
       /*                 DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT)     +  */
       /*                 SNDFMT(*NOTE) DOCD('HONDA LATE EDI ORDER +  */
       /*                 AFTER 10 REPORT')                           */

             DLTOVR     FILE(PRT132)

             ENDPGM
