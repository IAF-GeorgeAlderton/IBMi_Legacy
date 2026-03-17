             PGM        PARM(&WORKER &WUSRID)
             /** AM#C45N ***********************/
             /* PALLET RETURN SCAN             */
             /*   LEC.             2019.10.30  */
             /**********************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WUSRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&WUSRID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

  /*******************************************************************/
             DLTF       FILE(QTEMP/AM#WP45G)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AM#WP45G) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AM#WP45G)

             OVRDBF     FILE(AM#WP45G) TOFILE(QTEMP/AM#WP45G)

  /*******************************************************************/

             CALL       PGM(AM#R45N) PARM(&WORKER &WUSRID)

             ENDPGM
