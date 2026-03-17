             PGM
             /** AB#C53 ********************************/
             /*  ..CUSTOMER ORDER LIST VERIFICATION..  */
             /*    I-HASADA                97.08.21    */
             /******************************** AB#C53 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             DLTF       FILE(AB#WP53)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AB#WP53) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AB#R53)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(AB#WP53)
             GOTO       END
             ENDDO

             IF         (%SWITCH(X0XXXXXX)) DO
             DLTF       FILE(AB#WP53)
             SNDPGMMSG  MSG('NO DATA ARAILABLE') TOMSGQ(&WSID)
             GOTO       END
             ENDDO

             DLTF       FILE(AB#WP54)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AB#WP54) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/AB#WP53)) +
                          OUTFILE(HWFILE1/AB#WP54) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S54) +
                          OPTION(*NOPRT)
             DLTF       FILE(AB#WP53)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AB#R54)
             DLTF       FILE(AB#WP54)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
