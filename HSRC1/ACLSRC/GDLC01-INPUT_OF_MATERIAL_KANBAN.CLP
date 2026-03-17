             PGM
             /** GDLC01 *************************************/
             /*  INPUT OF MATERIAL KANBAN                   */
             /*  K.YASUDA  2000.07.03                       */
             /*  JW1       2022.05.24 ADD LOG PROGRAM       */
             /***********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG ) TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     SWS(00000000)

     /* JW1 SAVE LOG UTLWP07D */
             CHGVAR     VAR(&MSG ) VALUE('GDLC01-GDLR01: SCAN KANBAN IN ')
             CALL       PGM(UTLR07D) PARM('GDLR01' &MSG)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*SCS) PAGESIZE(66 80) +
                          RPLUNPRT(*YES) OUTQ(LANPRT02) FORMTYPE(K6S1)

             CALL       PGM(GDLR01) PARM(&USER)
             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       END
             ENDDO

             CALL       PGM(GDLR02) PARM(&USER)
             DLTOVR     FILE(*ALL)

     /* JW1 SAVE LOG UTLWP07D */
             CHGVAR     VAR(&MSG ) VALUE('GDLC01-GDLR01: SCAN KANBAN OUT')
             CALL       PGM(UTLR07D) PARM('GDLR01' &MSG)

 END:        ENDPGM
