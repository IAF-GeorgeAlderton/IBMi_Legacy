             PGM
             /*** GKBC26 *************************************/
             /* EACH FACTORY MATERIALS PROD.    ORDER M/F ACCOUNT BOOK CREATE */
             /*         H.ITO              88.10.18          */
             /************************************* GKBC26 ***/
             DCLF       FILE(GKBPW26)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WS)     USER(&USER)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

 STP1:       SNDRCVF    DEV(&WS) RCDFMT(GKBPW261)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')

             IF         (&@BMON *EQ '    ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG)  VALUE('MANAGEMENT SECTION IS NOT INPUT.')
             GOTO STP1
             ENDDO

             IF         COND((&@BMON *NE '0111') *AND (&@BMON *NE +
                          '9999')) THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('MANAGEMENT SECTION IS NOT RIGHT.')
             GOTO STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1

             OVRPRTF    FILE(GKBPR26) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) RPLUNPRT(*YES ' ') +
                          OUTQ(QPRINTA) FORMTYPE(K6H1)

             CALL       PGM(GKBR26) PARM(&@BMON)

             DLTOVR     FILE(GKBPR26)
 END:        ENDPGM
