             PGM
             /** ABBC9A *****************************************/
             /*  FLAG INVENETORY                                */
             /*                                                 */
             /***************************************** ABBC9A **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             ADDLIBLE   LIB(HWFILE1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(HFILE1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(HOBJ1)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(ABBR9A)
             SIGNOFF

             ENDPGM
