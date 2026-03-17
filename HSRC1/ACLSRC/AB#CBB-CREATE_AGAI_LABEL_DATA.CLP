             PGM
             /** AB#CBB ***********************************************/
             /*  ..PRINT TMS CASE LABEL                               */
             /*                                                       */
             /*                                                       */
             /***************************** AB#C2C ********************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(AB#WP2Q)

             CALL       PGM(AB#RBB)

             CPYF       FROMFILE(AB#WP2Q) TOFILE(HWFILE1/AB#WP2QS) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)

             ENDPGM
