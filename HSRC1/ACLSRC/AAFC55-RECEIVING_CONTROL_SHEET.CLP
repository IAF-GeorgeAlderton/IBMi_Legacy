             PGM
             /** AAFC55 ***********************/
             /*  ..RECEIVING CONTROL SHEET..  */
             /*    I-HASADA       97.08.15    */
             /*  CHANGE OUTQ                  */
             /*    K-KASHIWAGI    01.04.23    */
             /*********************** AAFC55 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CLRPFM     FILE(AAFWP55)

             CALL       PGM(AAFR55)

             IF         (%SWITCH(0XXXXXXX)) DO
             CLRPFM     FILE(AAFWP55)
             GOTO       END
             ENDDO

             OVRPRTF    FILE(AAFPR56) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTB) FORMTYPE(@972)
             CALL       PGM(AAFR56)
             CLRPFM     FILE(AAFWP55)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
