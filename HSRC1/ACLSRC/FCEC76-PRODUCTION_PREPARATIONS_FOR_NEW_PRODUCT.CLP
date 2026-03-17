             PGM
             /** FCEC76 ***************************************/
             /*  ..PRODUCTION PREPARATIONS FOR NEW PRODUCT..  */
             /*    I-HASADA                       97.08.12    */
             /*************************************** FCEC76 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSKEI) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             DLTF       FILE(FCEWP76)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/FCEWP76) RCDLEN(200) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(FCER76) PARM(&PSKEI)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(FCEWP76)
             GOTO       END
             ENDDO

             DLTF       FILE(FCEWP77)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/FCEWP77) RCDLEN(200) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/FCEWP76)) +
                          OUTFILE(HWFILE1/FCEWP77) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(FCES77) +
                          OPTION(*NOPRT)
             DLTF       FILE(FCEWP76)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(FCER77) PARM(&PSKEI)
             DLTF       FILE(FCEWP77)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
