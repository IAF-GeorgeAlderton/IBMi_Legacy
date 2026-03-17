             PGM
             /** IZAC20 ***********************************/
             /* ISSUING REPORT FORM FOR NEW ROD MATERIAL  */
             /*   I-HASADA                  2000.07.28    */
             /*********************************** IZAC20 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL3) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FIL1) VALUE(IZAWP201 *CAT &WS)
             CHGVAR     VAR(&FIL2) VALUE(IZAWP202 *CAT &WS)
             CHGVAR     VAR(&FIL3) VALUE(IZAWP21 *CAT &WS)

             DLTF       FILE(&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL1) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL2) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(IZAWP201) TOFILE(&FIL1)
             OVRDBF     FILE(IZAWP202) TOFILE(&FIL2)
             CALL       PGM(IZAR20)
             DLTOVR     FILE(*ALL)

             IF         (%SWITCH(00XXXXXX)) DO
             DLTF       FILE(&FIL1)
             DLTF       FILE(&FIL2)
             GOTO       END
             ENDDO

             IF         (%SWITCH(1XXXXXXX)) DO

             DLTF       FILE(&FIL3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL3) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FIL1)) +
                          OUTFILE(HWFILE1/&FIL3) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(IZAS21) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FIL1)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) ALIGN(*YES) OUTQ(&PRTG) +
                          FORMTYPE(D973)
             OVRDBF     FILE(IZAWP21) TOFILE(&FIL3)
             CALL       PGM(IZAR21)
             DLTF       FILE(&FIL3)
             DLTOVR     FILE(*ALL)

             ENDDO

             IF         (%SWITCH(X1XXXXXX)) DO

             DLTF       FILE(&FIL3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL3) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FIL2)) +
                          OUTFILE(HWFILE1/&FIL3) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(IZAS21) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FIL2)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) ALIGN(*YES) OUTQ(&PRTG) +
                          FORMTYPE(D973)
             OVRDBF     FILE(IZAWP21) TOFILE(&FIL3)
             CALL       PGM(IZAR21)
             DLTF       FILE(&FIL3)
             DLTOVR     FILE(*ALL)

             ENDDO

 END:        ENDPGM
