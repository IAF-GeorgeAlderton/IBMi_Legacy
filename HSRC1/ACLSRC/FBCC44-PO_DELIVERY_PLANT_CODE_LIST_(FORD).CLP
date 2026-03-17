             PGM
             /** FBCC44 ************************************/
             /*  PO/DELIVERY/PLANT CODE LIST (FORD)        */
             /*  W.WATANABE  2018.03.20                    */
             /**********************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 /* CREATE WORK FILE IN QTEMP */
             DLTF       FILE(QTEMP/FBCWP44)
             MONMSG     MSGID(CPF3261 CPF2105)
          CRTDUPOBJ  OBJ(FBCWP44) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/FBCWP45)
             MONMSG     MSGID(CPF3261 CPF2105)
          CRTDUPOBJ  OBJ(FBCWP45) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(FBCR44)

 /* CPOY TO ISF */
             CHGVAR     VAR(&FNAM) VALUE('Ford PO.Delivery.Plant List')
             CALL  PGM(APLC94) PARM('2' 'FBCWP45' 'QTEMP' &FNAM 'Y' ' ' 'Y')

             ENDPGM
