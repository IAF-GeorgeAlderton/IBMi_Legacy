             PGM        PARM(&SFIL &SLIB)
             /** EB#C0S ******************************************/
             /*  B2B FORD ASN CHECK LIST                         */
             /*    T.SAKAKI      06/07/2017                      */
             /****************************************** AB#C0S **/
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&SFIL)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)

     /*--------------------------*/
     /*    CHECK ENVIRONMENT     */
     /*--------------------------*/
             RTVJOBA    USER(&USR)
             CALL       PGM(ALBC01) PARM(&USR &PLIB &WLIB)

             RTVMBRD    FILE(&SLIB/&SFIL) NBRCURRCD(&REC)
             IF         COND(&REC *GT 0) THEN(DO)

     /* EB#WP66 -> QPRINT */
             DLTF       FILE(QTEMP/PRT132)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/PRT132) RCDLEN(132)

     /* EB#WP66 -> QPRINT */
             OVRPRTF    FILE(QPRINT) OUTQ(QPRINTB) SAVE(*YES)
             OVRDBF     FILE(EB#WP66) TOFILE(&SLIB/&SFIL)
             CALL       PGM(EB#R0S)
             DLTOVR     FILE(QPRINT)

             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132) +
                          JOB(&NBR/&USR/&JOB) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(SKP))
             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132)
             CALL       PGM(AB#RW0)

             DLYJOB     DLY(30)
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('takashi.sakaki@iafi.com')) +
                          DSTD('FORD ASN CHECK LIST') MSG('Ford ASN +
                          data has been created. Please check the +
                          list. (EB#C0S)') DOCFILE(QTEMP/PRT132) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('FORD +
                          EDI ASN DATA')

             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USR/&JOB) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
 SKP:
             ENDDO

             ENDPGM
