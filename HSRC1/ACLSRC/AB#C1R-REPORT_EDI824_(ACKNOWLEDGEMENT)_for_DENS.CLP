             PGM
             /** AB#C1R **********************************************/
             /*  REPORT EDI824 (ACKNOWLEDGEMENT) FOR DENSO           */
             /*  JW     2019.05.17                                   */
             /*  JW     2019.08.13 ADD PISTON                        */
             /********************************************************/
             DCL        VAR(&CNT)   TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(1)

             DCL        VAR(&ERR)  TYPE(*CHAR) LEN(21) VALUE(' ')
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(120)

/* CHECK TARGET */
             RTVMBRD    FILE(AB#PP6M) NBRCURRCD(&CNT)
             IF         (&CNT *EQ 0) THEN(GOTO ENDP)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT)  OUTQ(SAVEOUTQ) HOLD(*YES)
             OVRDBF     FILE(AB#EP60S) TOFILE(HFILE1/AB#EP60S)

/* (DENSO  )=========================================================*/
             CALL       PGM(AB#R1R) PARM('DENSO ' &RTN)

             IF         (&RTN *NE ' ') THEN(DO)
             CPYSPLF    FILE(QPRINT ) TOFILE(HWFILE1/PRT132) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132)
             CALL       PGM(AB#RW0)

             CHGVAR     VAR(&ERR) VALUE('                     ')
             IF         COND(&RTN *EQ '*') THEN(CHGVAR VAR(&ERR) +
                          VALUE('** REJECT CONTAINS **'))

             CHGVAR     VAR(&MSG) VALUE(&ERR *BCAT 'DENSO EDI824 +
                          Text Message Has Been Processed. Please +
                          Check The Attached List. (AB#C1R).')
/* SEND MSG BY MAIL */
                       /* TOINTNET((EDI824MessageCOMMON@iafi.com)) +    */
             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDI824MessageCOMMON@iafi.com)) +
                          DSTD('DENSO EDI824 Text Message') +
                          MSG(&MSG) DOCFILE(HWFILE1/PRT132) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('DENSO +
                          EDI824 Text Message')

             DLTOVR     FILE(PRT132)
             DLTSPLF    FILE(QPRINT6) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             ENDDO

/* (SUBARU )=========================================================*/
             CALL       PGM(AB#R1R) PARM('SUBARU' &RTN)

             IF         (&RTN *NE ' ') THEN(DO)
             CPYSPLF    FILE(QPRINT ) TOFILE(HWFILE1/PRT132) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132)
             CALL       PGM(AB#RW0)

             CHGVAR     VAR(&ERR) VALUE('                     ')
             IF         COND(&RTN *EQ '*') THEN(CHGVAR VAR(&ERR) +
                          VALUE('** REJECT CONTAINS **'))

             CHGVAR     VAR(&MSG) VALUE(&ERR *BCAT 'SUBARU EDI824 +
                          Text Message Has Been Processed. Please +
                          Check The Attached List. (AB#C1R).')
/* SEND MSG BY MAIL */
                       /* TOINTNET((EDI824MessageTMS@iafi.com)) +    */
             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDI824MessageCOMMON@iafi.com)) +
                          DSTD('SUBARU EDI824 Text Message') +
                          MSG(&MSG) DOCFILE(HWFILE1/PRT132) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('SUBARU +
                          EDI824 Text Message')

             DLTOVR     FILE(PRT132)
             DLTSPLF    FILE(QPRINT6) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* (PISTON )=========================================================*/
             CALL       PGM(AB#R1R) PARM('PISTON' &RTN)

             IF         (&RTN *NE ' ') THEN(DO)
             CPYSPLF    FILE(QPRINT ) TOFILE(HWFILE1/PRT132) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132)
             CALL       PGM(AB#RW0)

             CHGVAR     VAR(&ERR) VALUE('                     ')
             IF         COND(&RTN *EQ '*') THEN(CHGVAR VAR(&ERR) +
                          VALUE('** REJECT CONTAINS **'))

             CHGVAR     VAR(&MSG) VALUE(&ERR *BCAT 'PISTON EDI824 +
                          Text Message Has Been Processed. Please +
                          Check The Attached List. (AB#C1R).')
/* SEND MSG BY MAIL */
                       /* TOINTNET((EDI824MessageTMS@iafi.com)) +    */
             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDI824MessageCOMMON@iafi.com)) +
                          DSTD('PISTON EDI824 Text Message') +
                          MSG(&MSG) DOCFILE(HWFILE1/PRT132) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('PISTON +
                          EDI824 Text Message')

             DLTOVR     FILE(PRT132)
             DLTSPLF    FILE(QPRINT6) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* ========================================================================*/

             DLTOVR     FILE(*ALL)

ENDP:        ENDPGM
