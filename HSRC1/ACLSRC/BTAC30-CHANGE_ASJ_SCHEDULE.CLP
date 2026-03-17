             PGM

             /** BTAC30 **************************************/
             /*  CHANGE ASJ SCHEDULE                         */
             /************************************************/
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USR)
             CALL       PGM(ALBC00) PARM(&USR &WLIB)

             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15)
             CALL       PGM(BTAR30)
             DLTOVR     FILE(*ALL)

             CPYF       FROMFILE(&WLIB/BTAWP30) +
                          TOFILE(QTEMP/BTAWP) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@END))

             CPYF       FROMFILE(QTEMP/BTAWP) +
                          TOFILE(&WLIB/BTAWP30) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@END))
 @END:
             ENDPGM
