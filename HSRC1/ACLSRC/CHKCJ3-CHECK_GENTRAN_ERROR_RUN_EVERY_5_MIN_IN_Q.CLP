             PGM
             /** CHKCJ3 **********************************************/
             /*  DAILY JOB: CHECK GENTRAN ERROR                      */
             /*             RUN EVERY 5 MINUTES IN QBATCH4/JOBCHK    */
             /********************************************************/

             DCL        VAR(&COUNTER) TYPE(*DEC) LEN(2)

             CHGVAR     VAR(&COUNTER) VALUE('12')

@NEXT:
    /* JW    CALL       PGM(CHKCJ2)  */
             CALL       PGM(CHKCJ4)

/* CHECK GENTRAN ERROR IN EDIOUTQ */
             CALL       PGM(CHGC01)

/* CHECK PLATING TRANSMISSION ERROR */
             IF         COND(&COUNTER *EQ 0 ) THEN(DO)
             CALL       PGM(CHKCJ8)
             CHGVAR     VAR(&COUNTER) VALUE('12')
             ENDDO

             DLYJOB     DLY(300)

             CHGVAR VAR(&COUNTER) VALUE(&COUNTER-1)

             GOTO       CMDLBL(@NEXT)

             ENDPGM
