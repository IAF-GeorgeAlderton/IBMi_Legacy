             PGM
             /** GCQC41 ************************************/
             /*  TABLE OF DIE FORCAST IN IAF               */
             /*  MSK.KUNIEDA                 98.05.20      */
             /**********************************************/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&RPY)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&SW1)    TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             /*-----------------------------------------------------*/
             CHGJOB     OUTQ(&PRTG)
             DLTF       FILE(HWFILE1/GCQWP41)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GCQWP41) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(500000 2000 5) +
                          LVLCHK(*NO)

             DLTF       FILE(HWFILE1/GCQWL41)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GCQWL41) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(500000 2000 5) +
                          LVLCHK(*NO)

             CHGVAR     VAR(&SW1) VALUE(' ')

             CALL       PGM(GCQR41) PARM(&SW1)
             IF         COND(SW1 *EQ '9') THEN(GOTO CMDLBL(END))

             FMTDTA     INFILE((HWFILE1/GCQWP41)) +
                          OUTFILE(HWFILE1/GCQWL41) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCQS42) +
                          OPTION(*NOPRT)

      /*     OVRPRTF    FILE(GCQPR42) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          198) LPI(6) CPI(15) OVRFLW(64) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) HOLD(*YES) */
             OVRPRTF    FILE(GCQPR42) PAGESIZE(66 198) LPI(6) +
                          CPI(15) OVRFLW(64) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) HOLD(*YES)

             OVRPRTF    FILE(GCQPR43) PAGESIZE(66 198) LPI(6) +
                          CPI(15) OVRFLW(64) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) HOLD(*YES)

             OVRPRTF    FILE(GCQPR44) PAGESIZE(66 198) LPI(6) +
                          CPI(15) OVRFLW(64) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(GCQR42) PARM(&USER)

             /*   ERROR LIST OF DIE FORCAST IN IAF */
      /*     OVRPRTF    FILE(GCQPR45) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) OVRFLW(64) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) HOLD(*YES)     */

             OVRPRTF    FILE(GCQPR45) PAGESIZE(66 132) OVRFLW(64) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(GCQR45) PARM(&USER)

             DLTOVR     FILE(*ALL)

 END:        CHGJOB     OUTQ(&PRT)

             DLTF       FILE(HWFILE1/GCQWP41)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(HWFILE1/GCQWL41)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM
