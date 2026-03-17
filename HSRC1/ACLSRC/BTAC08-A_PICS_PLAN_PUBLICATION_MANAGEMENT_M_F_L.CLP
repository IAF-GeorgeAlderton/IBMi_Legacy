             PGM
             /** BTAC08 *******************************************/
             /*  ..A-PICS PLAN PUBLICATION MANAGEMENT M/F LIST..  */
             /*    COPY FROM BTAC09                 2000.10.16    */
             /******************************************* BTAC08 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKEYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             DLTF       FILE(BTAWP08)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/BTAWP08) RCDLEN(300) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(BTAR08) PARM(&PKEYM)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(BTAWP08)
             GOTO       END
             ENDDO

             DLTF       FILE(BTAWP081)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/BTAWP081) RCDLEN(300) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/BTAWP08)) +
                          OUTFILE(HWFILE1/BTAWP081) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(BTAS10) +
                          OPTION(*NOPRT)
             DLTF       FILE(BTAWP08)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             OVRDBF     FILE(BTAWP10) TOFILE(BTAWP081)
             CALL       PGM(BTAR10) PARM(&PKEYM)
             DLTF       FILE(BTAWP081)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
