             PGM
             /** INVC1B ************************************/
             /*   UPDATE OF INVENTORY FILE                 */
             /*                                            */
             /*               CREATE DATE : 2015.06.09     */
             /*               KIRI                         */
             /**********************************************/
             DCLF       FILE(INVPW1D)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

 @STP00:
             SNDRCVF    DEV(&WSID) RCDFMT(INVPW1D1)
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))

             IF         COND(&D1NO *EQ '1') THEN(GOTO CMDLBL(@STP01))
             IF         COND(&D1NO *EQ '2') THEN(GOTO CMDLBL(@STP02))
             IF         COND(&D1NO *EQ '3') THEN(GOTO CMDLBL(@STP03))

             CHGVAR     VAR(&MSG) VALUE('INPUT # IS INCORRECT')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(@STP00)



 @STP01:
             CALL       PGM(INVR1B)
             GOTO       CMDLBL(@STP00)

 @STP02:
             CALL       PGM(INVR1C)
             GOTO       CMDLBL(@STP00)

 @STP03:
             CALL       PGM(INVR1E)
             GOTO       CMDLBL(@STP00)


 @END:
             ENDPGM
