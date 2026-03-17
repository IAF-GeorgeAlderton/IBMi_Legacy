             PGM
             /*** MCEC47 ***************************************/
             /* TOTAL ABOLISHED PART NUMBER M/F ACCOUNT BOOK <CHANGE DATE> */
             /*          H.ITO             90.02.19            */
             /*************************************** MCEC47 ***/
             DCL        VAR(&WSNO)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&RPY)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSNO) USER(&PARM4)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSNO &PDEVT &PIGCD)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSNO 1 2))
             CHGVAR     VAR(&FILE1) VALUE('MCEWP47' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('MCEWP48' *CAT &WS)

             CHGJOB     OUTQ(&PRTG) SWS(00000000)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(128) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MCEWP47) TOFILE(&FILE1)
             CALL       PGM(MCER47) PARM(&PARM1 &PARM2 &PARM3)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(&FILE1)
             DLTOVR     FILE(MCEWP47)
             GOTO       END
             ENDDO

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(128) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             IF         (&PARM3  *EQ 'A')  DO
             FMTDTA     INFILE((&FILE1)) OUTFILE(&FILE2) +
                          SRCFILE(FMTSRC) SRCMBR(MCES47) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             ENDDO

             IF         (&PARM3  *EQ 'B')  DO
             FMTDTA     INFILE((&FILE1)) OUTFILE(&FILE2) +
                          SRCFILE(FMTSRC) SRCMBR(MCES48) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             ENDDO

             OVRPRTF    FILE(MCEPR48) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             OVRDBF     FILE(MCEWP48) TOFILE(&FILE2)
             CALL       PGM(MCER48) PARM(&PARM1 &PARM2 &PARM3 &PARM4)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
