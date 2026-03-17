             PGM
             /** GDLC85 *****************************/
             /*  PRINTING MATERIAL UNIT PRICE LIST  */
             /*               K.YASUDA  2000.10.02  */
             /***************************** GDLC85 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KEN) TYPE(*DEC) LEN(10 0)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     SWS(00000000)

             DLTF       FILE(GDLWP85)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GDLWP85) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(GDLR85)

             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
             GOTO       END
             ENDDO

             DLTF       FILE(GDLWP86)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GDLWP86) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/GDLWP85)) +
                          OUTFILE(HWFILE1/GDLWP86) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GDLS85) +
                          OPTION(*NOPRT)
             DLTF       FILE(GDLWP85)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 132) OVRFLW(60) +
                          OUTQ(QPRINT) FORMTYPE(K6H1)

             CALL       PGM(GDLR86) PARM(&USER)

             DLTOVR     FILE(*ALL)
 END:        ENDPGM
