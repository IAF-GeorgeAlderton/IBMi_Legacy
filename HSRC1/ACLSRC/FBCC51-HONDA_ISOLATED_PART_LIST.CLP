             PGM
/** FBCC51 *************************************************/
/*  HONDA ISOLATED PART LIST                               */
/*                                                         */
/*  J.WATANABE 02/21/2018                                  */
/***********************************************************/

             DCLF       FILE(FBCPW51)
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&I2 ) TYPE(*CHAR) LEN( 2)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WS) USER(&USR)

 STP1:       SNDRCVF    DEV(&WS) RCDFMT(DSP01)
             IF         (&IN03 *EQ '1') GOTO END

             IF         (&IN05 *NE '1') GOTO STP1

             CHGVAR     VAR(&I2) VALUE(%SST(&USR 1 2))

     /*SALES*/
            IF         COND(&I2 *EQ 'I3') THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT50)
            ENDDO
     /*NOT SALES*/
            IF         COND(&I2 *NE 'I3') THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03)
            ENDDO

             CALL       PGM(FBCR51)

END:         ENDPGM
