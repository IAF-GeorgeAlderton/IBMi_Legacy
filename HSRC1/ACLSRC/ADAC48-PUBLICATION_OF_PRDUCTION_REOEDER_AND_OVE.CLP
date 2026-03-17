             PGM
             /** ADAC48 ***********************************/
             /*PUBLICATION OF PRDUCTION REOEDER AND OVER MADE DATA CHECK LIST*/
             /*                S.YAMAGMI 92.03.25 */
             /*********************************************/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&HIZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID) USER(&US)
             CHGJOB     SWS(00000000)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FIL1) VALUE('ADAWP48' *CAT &WS)
             CHGVAR     VAR(&FIL2) VALUE('ADAWP49' *CAT &WS)

      /* WORK 1 */
             DLTF       FILE(&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL1) RCDLEN(50) OPTION(*NOLIST +
                          *NOSRC) SIZE(9999 100) LVLCHK(*NO)

             OVRDBF     FILE(ADAWP48) TOFILE(&FIL1)
             CALL       PGM(ADAR48) PARM(&US &NO &HIZ)

             IF         (%SWITCH(00XXXXXX)) DO
             DLTF       FILE(&FIL1)
             DLTOVR     FILE(ADAWP48)
             GOTO       END
             ENDDO

      /* WORK 2 */
             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL2) RCDLEN(50) OPTION(*NOLIST +
                          *NOSRC) SIZE(9999 100) LVLCHK(*NO)

     /* INPUT ORDER */
             IF         (%SWITCH(1XXXXXXX)) DO
             OVRDBF     FILE(ADAWP49) TOFILE(&FIL1)
             GOTO       CMDLBL(STEP1)
             ENDDO

     /* LOCATION CODE ORDER */
             IF         (%SWITCH(X1XXXXXX)) DO
             FMTDTA     INFILE((HWFILE1/&FIL1)) +
                          OUTFILE(HWFILE1/&FIL2) SRCFILE(FMTSRC) +
                          SRCMBR(ADAS48) OPTION(*NOPRT)
             OVRDBF     FILE(ADAWP49) TOFILE(&FIL2)
             ENDDO

 STEP1:      OVRPRTF    FILE(ADAPR49) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(QPRINTA) FORMTYPE(K6S1)

             CALL       PGM(ADAR49) PARM(&US &NO &HIZ)
             DLTF       FILE(&FIL1)
             DLTF       FILE(&FIL2)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
