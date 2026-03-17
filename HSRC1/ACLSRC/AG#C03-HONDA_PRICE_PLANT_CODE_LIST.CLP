             PGM
/** AG#C03 *************************************************/
/*  HONDA PRICE PLANT CODE LIST                            */
/*                                                         */
/*  J.WATANABE 02/21/2018                                  */
/***********************************************************/

             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&I2 ) TYPE(*CHAR) LEN( 2)

             RTVJOBA    USER(&USR)

             CHGVAR     VAR(&I2) VALUE(%SST(&USR 1 2))

     /*SALES*/
            IF         COND(&I2 *EQ 'I3') THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT50)
            ENDDO
     /*NOT SALES*/
            IF         COND(&I2 *NE 'I3') THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03)
            ENDDO

             CALL       PGM(AG#R03)

             ENDPGM
