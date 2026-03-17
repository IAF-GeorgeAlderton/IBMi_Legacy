         PGM
         /** MBDCTA *****************************************/
         /*  PART WITH MACHINE REPORT                       */
         /*  J.WATANABE    2021.05.17                       */
         /***************************************************/
             DCL        VAR(&REC)   TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR )  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

/* CREATE WF */
             DLTF       FILE(QTEPM/MBDWLTA)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEPM/MBDWPTA)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(MBDWPTA) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(MBDWPTA)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(MBDWLTA) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(MBDWLTA)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/MBDWPTB)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(MBDWPTB) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(MBDWPTB)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(MBDWPTA) TOFILE(QTEMP/MBDWPTA)
             OVRDBF     FILE(MBDWLTA) TOFILE(QTEMP/MBDWLTA)
             OVRDBF     FILE(MBDWPTB) TOFILE(QTEMP/MBDWPTB)

             CALL       PGM(MBDRTA)

             CALL       PGM(MBDRTB)

 ENDP:       ENDPGM
