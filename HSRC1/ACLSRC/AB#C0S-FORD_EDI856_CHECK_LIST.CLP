             PGM
             /** AB#C0S **********************************************/
             /*  FORD ASN CHECK LIST                                 */
             /*  JW   2025.09.19                                     */
             /********************************************************/

             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)

             OVRDBF     FILE(AB#EP66) TOFILE(HFILE1/AB#EP66Q)

             OVRPRTF    FILE(QPRINT) OUTQ(QPRINTB) SAVE(*YES)

             CALL       PGM(AB#R0S)

             DLTOVR     FILE(QPRINT)

             RTVMBRD    FILE(AB#EP66Q) NBRCURRCD(&REC)

             IF         COND(&REC *GT 0) THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132) +
                          JOB(&NBR/&USR/&JOB) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(SKP))
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) TOINTNET((Kaz.Watanabe@iafi.com) +
                          (jonathon.julson@iafi.com) +
                          (Larry.Cox@iafi.com)) DSTD('FORD ASN +
                          CHECK LIST') MSG('Ford ASN data has been +
                          created. Please check the list. +
                          (AB#C0S)') USRID(*CURRENT) +
                          DOCFILE(HWFILE1/PRT132) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('FORD EDI ASN DATA - +
                          GENTRAN')

/** PROD     SNDDST     TYPE(*FILE) TOINTNET(('FordASN@iafi.com')) +    **/
/**                       DSTD('FORD ASN CHECK LIST') MSG('Ford ASN +   **/
/**                       data has been created. Please check the +     **/
/**                       list. (AB#C0S)') DOCFILE(HWFILE1/PRT132) +    **/
/**                       DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('FORD +      **/
/**                       EDI ASN DATA')                                **/

             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USR/&JOB) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
 SKP:
             ENDDO

             ENDPGM
