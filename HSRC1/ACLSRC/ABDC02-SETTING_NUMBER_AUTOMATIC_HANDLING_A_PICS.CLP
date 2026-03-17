             PGM
             /** ABDC02 ***********************************/
             /* SETTING NUMBER AUTOMATIC HANDLING A-PICS FIXED INCREASE AND */
             /*                            DECRASE LIST */
             /* A-PICS1                                 */
             /* ABDC0B CHANGE                        */
             /* KOHHY.                   90.11.28         */
             /*********************************** ABDC02 **/
             DCLF       FILE(ABDPW02)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&HIZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&YMJ) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVDTAARA  DTAARA(ABDDS1) RTNVAR(&HIZ)
             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&YMJ)
             CHGJOB     SWS(00000000)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ABDPW021)
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IN02 *EQ '1') GOTO END

             IF         (&IN05 *NE '1') GOTO STP1

             DLTF       FILE(ABDWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABDWP02) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(50000 5000 5) +
                          LVLCHK(*NO)

             CALL       PGM(ABDR02)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(ABDWP02)
             GOTO       END
             ENDDO

             DLTF       FILE(ABDWP03)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABDWP03) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(50000 5000 5) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/ABDWP02)) +
                          OUTFILE(HWFILE1/ABDWP03) SRCFILE(FMTSRC) +
                          SRCMBR(ABDS02) OPTION(*NOPRT)
             DLTF       FILE(ABDWP02)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(ABDR03) PARM(&YMJ &HIZ)
             DLTF       FILE(ABDWP03)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
