             PGM
             /** AAFC61 **************************/
             /*DATA LOCATION CODE ORDER LIST  FOR AUTOMATIC WEIGHING */
             /* E.KAWASHIMA G.B.C 89.08.19 */
             /************************** AAFC61 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WS)
             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&WT) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FILE1) VALUE('AAFWP61' *CAT &WT)
             CHGVAR     VAR(&FILE2) VALUE('AAFWP62' *CAT &WT)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 3000 3) +
                          LVLCHK(*NO)

             OVRDBF     FILE(AAFWP61) TOFILE(&FILE1)
             CALL       PGM(AAFR61)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(&FILE1)
             GOTO       END
             ENDDO

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 3000 3) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(AAFS61) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             OVRDBF     FILE(AAFWP62) TOFILE(&FILE2)
             CALL       PGM(AAFR62)

     /*      DLTF FILE(&FILE2) */

             DLTOVR     FILE(*ALL)

 END:        ENDPGM
