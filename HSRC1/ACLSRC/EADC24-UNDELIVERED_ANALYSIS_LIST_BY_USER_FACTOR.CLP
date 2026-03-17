             PGM        PARM(&USR &STHZ &ENHZ &YMD)
             /** EADC24 **************************/
             /* UNDELIVERED ANALYSIS LIST BY USER FACTORY */
             /* E.KAWASHIMA G.B.C 89.03.02 */
             /************************** EADC24 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&STHZ)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&ENHZ)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&YMD)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WS)
             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&WT) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FILE1) VALUE('EADWP25' *CAT &WT)
             CHGVAR     VAR(&FILE2) VALUE('EADWP26' *CAT &WT)

   /*        CALL       PGM(KZZR00) PARM(&WS &PRT &TYPE &PRTG)    */
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(200) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 3000 3) +
                          LVLCHK(*NO)

             OVRDBF     FILE(EADWP25) TOFILE(&FILE1)
             CALL       PGM(EADR24) PARM(&USR &STHZ &ENHZ &YMD)

             IF         (%SWITCH(0XXXXXXX)) DO
                DLTF       FILE(&FILE1)
                GOTO       END
             ENDDO

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(200) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 3000 3) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((&FILE1)) OUTFILE(&FILE2) +
                          SRCFILE(FMTSRC) SRCMBR(EADS24) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             OVRDBF     FILE(EADWP26) TOFILE(&FILE2)
             CALL       PGM(EADR25)
             DLTF       FILE(&FILE2)

             DLTOVR     FILE(*ALL)

 END:        ENDPGM
