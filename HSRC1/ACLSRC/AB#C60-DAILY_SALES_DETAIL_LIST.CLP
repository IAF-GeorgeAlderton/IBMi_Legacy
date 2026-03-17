             PGM
             /** AB#C60 ************************/
             /*  ..DAILY SALES DETAIL  LIST..  */
             /*    I-HASADA        97.08.05    */
             /*                                */
             /*  AB#WP60 -> QTEMP              */
             /*                                */
             /************************ AB#C60 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PNONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             DLTF       FILE(QTEMP/AB#WP60)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP60) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP60) TOFILE(QTEMP/AB#WP60)

             CALL       PGM(AB#R60) PARM(&PNONY)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(QTEMP/AB#WP60)
             GOTO       END
             ENDDO

             IF         (%SWITCH(X0XXXXXX)) DO
             DLTF       FILE(QTEMP/AB#WP60)
             SNDPGMMSG  MSG('NO DATA AVAILABLE') TOMSGQ(&WSID)
             GOTO       END
             ENDDO

             IF         (%SWITCH(XX1XXXXX)) DO
             SNDPGMMSG  MSG('UNIT PRICES ARE NOT REGISTERED') +
                          TOMSGQ(&WSID)
             ENDDO

             DLTF       FILE(QTEMP/AB#WP61)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP61) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((QTEMP/AB#WP60)) +
                          OUTFILE(QTEMP/AB#WP61) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S60) +
                          OPTION(*NOPRT)
             DLTF       FILE(QTEMP/AB#WP60)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)

             OVRDBF     FILE(AB#WP61) TOFILE(QTEMP/AB#WP61)

             CALL       PGM(AB#R61) PARM(&PNONY)
             DLTF       FILE(QTEMP/AB#WP61)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
