             PGM
             /** CAAC40 **************************/
             /*   A-PICS2 USAGE RECORD ENTRY     */
             /*       T-SAKAKI    2020.08.19     */
             /************************** CAAC40 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN1) TYPE(*CHAR) LEN(1)

             RTVJOBA    USER(&USER)
             CHGJOB     SWS(00000000)
    /********************************/
    /* CHECK LIBRARY                */
    /********************************/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

    /********************************/
    /* CHECK UNLOCK MANAGEMENT      */
    /********************************/
             CALL       PGM(CHKC45) PARM('CAAC40ACT' 'CAAC40' 'Y' +
                          'CHK' &RTN1)
              IF         COND(&RTN1 *NE ' ') THEN(GOTO SEND)

    /********************************/
    /* ENTRY SCREEN                 */
    /********************************/
 STP1:       CLRPFM     FILE(&WLIB/CAAWP40)
             CALL       PGM(CAAR40)

    /* ERROR HAPPENED  */
             IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)
             GOTO       CMDLBL(UEND)
             ENDDO

    /********************************/
    /* WRITE USAGE RESULT           */
    /********************************/
             CALL       PGM(CAAR41) PARM(&USER)

    /********************************/
    /* UNLOCK                       */
    /********************************/
 UEND:       CALL       PGM(CHKC45) PARM('CAAC40ACT' 'CAAC40' 'N' '' +
                          '')

 SEND:       ENDPGM
