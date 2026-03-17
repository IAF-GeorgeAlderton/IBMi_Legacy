             PGM        PARM(&OBJ)
             /* CMDOBJ**************************************/
             /* COMMAND WRKOBJ                             */
             /* JW      2024.01.04                         */
             /**********************************************/
             DCL        VAR(&OBJ)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

             WRKOBJ     OBJ(*ALL/&OBJ)

             MONMSG     MSGID(CPF0001) EXEC(SNDBRKMSG MSG('parameter +
                          error!') TOMSGQ(&WSID))

             ENDPGM
