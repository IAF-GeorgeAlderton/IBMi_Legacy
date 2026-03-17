             PGM
             /** BTAC09 *******************************************/
             /*  ..A-PICS PLAN PUBLICATION MANAGEMENT M/F LIST..  */
             /*    I-HASADA                           97.08.14    */
             /******************************************* BTAC09 **/
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

             DLTF       FILE(BTAWP09)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/BTAWP09) RCDLEN(300) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(BTAR09) PARM(&PKEYM)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(BTAWP09)
             GOTO       END
             ENDDO

             DLTF       FILE(BTAWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/BTAWP10) RCDLEN(300) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/BTAWP09)) +
                          OUTFILE(HWFILE1/BTAWP10) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(BTAS10) +
                          OPTION(*NOPRT)
             DLTF       FILE(BTAWP09)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(BTAR10) PARM(&PKEYM)
             DLTF       FILE(BTAWP10)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
