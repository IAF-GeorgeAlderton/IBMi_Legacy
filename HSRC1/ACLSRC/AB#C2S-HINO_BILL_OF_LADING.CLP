             PGM
             /** AB#C2M ***********************************************/
             /*  ..HINO SKID LABEL                                    */
             /*                                                       */
             /*                                                       */
             /***************************** AB#C2M ********************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKSID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHKOBJ     OBJ(AB#WPBD) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WPBD) +
                          MBR(&WKSID))

             CLRPFM     FILE(AB#WPBD) MBR(&WKSID)
             OVRDBF     FILE(AB#WPBD) TOFILE(&WLIB/AB#WPBD) MBR(&WKSID)

             CALL       PGM(AB#R2S)
             DLTOVR     FILE(*ALL)


             ENDPGM
