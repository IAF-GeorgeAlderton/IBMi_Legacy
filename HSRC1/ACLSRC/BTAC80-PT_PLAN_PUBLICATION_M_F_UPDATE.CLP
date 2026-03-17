             PGM
             /*** BTAC80 *******************************/
             /* PT PLAN PUBLICATION M/F UPDATE         */
             /*         T.SAKASHITA 2004.09.24         */
             /******************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHKOBJ     OBJ(&WLIB/BTAC80ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@RUN))

STEP0:
             SNDPGMMSG  MSG('( G ) THIS PROCESSING IS BEING +
                          PROCESSED WITH OTHER COMPUTERS.') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND(&KOTE *NE 'G') THEN(GOTO CMDLBL(STEP0))
             GOTO       CMDLBL(@END)

@RUN:
             CRTDTAARA  DTAARA(&WLIB/BTAC80ACT) TYPE(*CHAR) LEN(10) +
                          VALUE(&USER) AUT(*ALL)

             DLTF       FILE(&WLIB/BTAWP80)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/BTAWP80) RCDLEN(9999) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

  /*TEST*/   CPYF       FROMFILE(MAMIYA/IAF) TOFILE(&WLIB/BTAWP80) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK) /*TEST*/

             CLRPFM     FILE(BTAPP80)

             /* PC -> BTAWP80 */

             /* BTAWP80 -> BTAPP80 */
             CALL       PGM(BTAR80)

             DLTF       FILE(&WLIB/BTAWP81)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/BTAWP81) RCDLEN(512) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             /* BTAPP80 -> BTAPP05 */
             CALL       PGM(BTAR81)

             DLTDTAARA  DTAARA(&WLIB/BTAC80ACT)

@END:        ENDPGM
