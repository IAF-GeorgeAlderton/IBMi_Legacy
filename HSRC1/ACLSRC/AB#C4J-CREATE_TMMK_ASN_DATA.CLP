             PGM
             /** AB#C4J ***********************************/
             /* CREATE TMMK ASN                            */
             /*                                            */
             /* N.HYOTO 2001.02.01                         */
             /************************************ AB#C4J **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLAG)  TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&FLAG) VALUE(' ')

             RTVJOBA    JOB(&WSID)  USER(&USER)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(&WLIB/EDI856TK)
             MONMSG     MSGID(CPF3156) EXEC(CHGVAR VAR(&FLAG) +
                          VALUE('1'))

             CALL       PGM(AB#R4J) PARM(&USER &FLAG)

             ENDPGM
