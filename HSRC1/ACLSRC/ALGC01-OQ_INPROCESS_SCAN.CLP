/** ALGC01 ************************************************/
/*  OQ INPROCESS SCAN                                     */
/*                                                        */
/* TCHK  07/21/11 CREATE                                  */
/* JW1   08/26/18 ADD SYSTEM AVAILABLE FLAG CHECK         */
/**********************************************************/
 PGM
     /* JW1 */
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)
             CALL       PGM(CHKC46) PARM(&RTN)
             IF         COND(&RTN = 'N') THEN(GOTO CMDLBL(ERR01))

             CALL      PGM(ALGR01)

ERR01:
             SIGNOFF

 ENDPGM:     ENDPGM
