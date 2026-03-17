             PGM
             /*** MCEC45 ***************************************/
             /* TOTAL ABOLISHED PART NUMBER M/F ACCOUNT BOOK <INPUT DATE> */
             /*          H.ITO             90.02.16            */
             /*************************************** MCEC45 ***/
             DCL        VAR(&WSNO)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&RPY)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSNO) USER(&PARM4)

             CALL       PGM(AGAR01) PARM(&WSNO &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSNO 1 2))
             CHGVAR     VAR(&FILE1) VALUE('MCEWP45' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('MCEWP46' *CAT &WS)

             CHGJOB     OUTQ(&PRTG) SWS(00000000)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(128) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MCEWP45) TOFILE(&FILE1)
             CALL       PGM(MCER45) PARM(&PARM1 &PARM2 &PARM3)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(&FILE1)
             DLTOVR     FILE(MCEWP45)
             GOTO       END
             ENDDO

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(128) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             IF         (&PARM3 *EQ 'A') DO
             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(MCES45) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             ENDDO

             IF         (&PARM3 *EQ 'B') DO
             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(MCES46) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             ENDDO

             OVRPRTF    FILE(MCEPR46) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             OVRDBF     FILE(MCEWP46) TOFILE(&FILE2)
             CALL       PGM(MCER46) PARM(&PARM1 &PARM2 &PARM3 &PARM4)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
