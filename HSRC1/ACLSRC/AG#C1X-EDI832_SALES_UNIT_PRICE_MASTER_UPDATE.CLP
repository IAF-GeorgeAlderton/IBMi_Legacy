  PGM
/** AG#C10 ************************************************/
/*  EDI832 SALES UNIT PRICE MASTER UPDATE                 */
/*                                                        */
/* TCHK  03/16/12 CREATE                                  */
/* T.SAKAKI 10/12/2015  ADD AG#R60                        */
/**********************************************************/

             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&CNT)   TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&CNT2)   TYPE(*DEC)  LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)


             RTVMBRD    FILE(TWFILE1/AG#WP30) NBRCURRCD(&CNT)

             IF         (&CNT *GT 0) THEN(DO)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) OUTQ(SAKAKI) FORMTYPE(K6H1) +
                          HOLD(*YES)

             OVRDBF     FILE(AG#WP30) TOFILE(TWFILE1/AG#WP30)
             CALL       PGM(HOBJ1/AG#R50)

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(HOBJ1/AB#RW0)
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('TAKASHI.SAKAKI@iafi.com')) +
                          DSTD('EDI832 PriceMaster Update Error +
                          Dup/differ') MSG('Got an error of +
                          duplicate or wrong effective data when +
                          received price master via 832. please +
                          check the attached list and take care of +
                          errors as needed.') +
                          DOCFILE(HWFILE1/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('EDI832 PriceMaster +
                          Update Error dup/differ')
             DLTOVR     FILE(PRT132)

             ENDDO
   /* add by sakaki */
             RTVMBRD    FILE(TWFILE1/AG#WP40) NBRCURRCD(&CNT2)

             IF         (&CNT2 *GT 0) THEN(DO)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) OUTQ(SAKAKI) FORMTYPE(K6H1) +
                          HOLD(*YES)

             OVRDBF     FILE(AG#WP40) TOFILE(TWFILE1/AG#WP40)
             CALL       PGM(AG#R60)

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(HOBJ1/AB#RW0)
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('TAKASHI.SAKAKI@iafi.com')) +
                          DSTD('EDI832 Price Master Update Error +
                          *New code*') MSG('Please check attached +
                          list and take care of the error.') +
                          DOCFILE(HWFILE1/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('EDI832 Price Master +
                          Update Error *New code*')
             DLTOVR     FILE(PRT132)

             ENDDO

ENDPGM:

             DLTOVR     FILE(*ALL)
             ENDPGM
