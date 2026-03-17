             PGM
             /** VJBC11 *************************************/
             /*  FILE REFORMATION MASTER  REFORM-REFERENCE  */
             /*    I-HASADA            87.11.04             */
             /********************************** VJBC11 *****/
             DCLF       FILE(VJBPW13)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(VJBPW131)

             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         ((&WNO *NE '1') *AND (&WNO *NE '2') *AND +
                          (&WNO *NE '3') *AND (&WNO *NE '4') *AND +
                          (&WNO *NE '5')) DO
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('NO.--> 1,2,3,4,5')

             GOTO       STP1
             ENDDO

             IF         (&WNO *EQ '1') DO
             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(VJBR11) PARM(&USER)
             CHGVAR     VAR(&WNO) VALUE(' ')
             GOTO       STP1
             ENDDO

             IF         (&WNO *EQ '2') DO
             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(VJBR12)
             CHGVAR     VAR(&WNO) VALUE(' ')
             GOTO       STP1
             ENDDO

             IF         (&WNO *EQ '3') DO
             CALL       PGM(AJBC25)
             GOTO       STP1
             ENDDO

     /*      IF         (&WNO *EQ '3') DO          */
     /*      CHGJOB     OUTQ(&PRTG)                */
     /*      CALL       PGM(VJBR19)                */
     /*      CHGVAR     VAR(&WNO) VALUE(' ')       */
     /*      GOTO       STP1                       */
     /*      ENDDO                                 */

             IF         (&WNO *EQ '4') DO
    /*       OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)  */
    /*       CALL       PGM(VJBR20) PARM(' ')         */
    /*       DLTOVR     FILE(QPRINT)                  */
    /*       CHGVAR     VAR(&WNO) VALUE(' ')          */
             GOTO       STP1
             ENDDO

             IF         (&WNO *EQ '5') DO
     /*      OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)   */
     /*      CALL       PGM(VJBR13)               */
     /*      DLTOVR     FILE(QPRINT)              */
     /*      CHGVAR     VAR(&WNO) VALUE(' ')      */
             GOTO       STP1
             ENDDO

 END:        ENDPGM
