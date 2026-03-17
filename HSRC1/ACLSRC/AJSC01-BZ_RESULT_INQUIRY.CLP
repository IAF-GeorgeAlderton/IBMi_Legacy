             PGM
             /** AJSC01 ************************************/
             /* BZ RESULT INQUIRY                          */
             /*               CREATE DATE : 2003/02/05     */
             /*               TCH                          */
             /**********************************************/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)  USER(&USER)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CRTDUPOBJ  OBJ(AJSWP01) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AJSWP01)
             OVRDBF     FILE(AJSWP01) TOFILE(QTEMP/AJSWP01)

             CALL AJSR01
             DLTOVR     FILE(*ALL)

             ENDPGM
