             PGM
             /** GDWC01 ************************/
             /* WAREHOUSE ORDER                */
             /* TCH13 1/06/05                  */
             /************************ GDGC77 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USR)
             CALL       PGM(ALBC00) PARM(&USR &WLIB)


             CLRPFM     FILE(&WLIB/GDWPP11)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(GDWR01)


             ENDPGM
