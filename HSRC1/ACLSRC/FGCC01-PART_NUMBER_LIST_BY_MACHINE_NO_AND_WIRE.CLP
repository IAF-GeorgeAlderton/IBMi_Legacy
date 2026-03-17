             PGM
             /** FGCC01 **************************/
             /* PART NUMBER  LIST BY MACHINE NO AND WIRE DIAMETER*/
             /* A-IDOTA 1995.05.08 */
             /************************** FGCC01 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KJYU) TYPE(*CHAR) LEN(4)
             DCL        VAR(&YYMM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WS)

             CHGVAR     VAR(&WT) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FILE1) VALUE('FGCWP01' *CAT &WT)
             CHGVAR     VAR(&FILE2) VALUE('FGCWP02' *CAT &WT)

             CHGJOB     SWS(00000000)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)

 STP1:
 /* WORK FILE CREATE FGCWP01 */
             OVRDBF     FILE(FGCWP01) TOFILE(&FILE1)
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(5000 2000 3) LVLCHK(*NO)

 /* PICK OUT  DATA   */
             CALL       PGM(FGCR01) PARM(&KJYU &YYMM)

             IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)
             DLTF       FILE(&FILE1)
             GOTO       CMDLBL(END)
             ENDDO

 /* WORK FILE CREATE FGCWP02 */
             OVRDBF     FILE(FGCWP02) TOFILE(&FILE2)
             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(5000 2000 3) LVLCHK(*NO)

 /* SORT */
             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(FGCS01) OPTION(*NOPRT)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES) OUTQ(QPRINTB) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)

 /* MAKING LIST*/
             CALL       PGM(FGCR02) PARM(&KJYU &YYMM)

             DLTF       FILE(&FILE1)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
