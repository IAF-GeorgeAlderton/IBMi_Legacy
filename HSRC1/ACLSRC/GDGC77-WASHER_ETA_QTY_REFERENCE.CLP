             PGM
             /** GDGC77 ************************/
             /* WASHER ETA QTY REFERENCE       */
             /*     TCH  2002/12/16            */
             /*     TCH04 2004/12/16           */
             /************************ GDGC77 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USR)
             CALL       PGM(ALBC00) PARM(&USR &WLIB)

             CRTDUPOBJ  OBJ(GDGWP77) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(GDGWL77) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(GDGWL78) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

      /* TCH04  */
             CLRPFM     FILE(&WLIB/GDGWP7DH)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(&WLIB/GDGWP7DD)
             MONMSG     MSGID(CPF0000)
      /* TCH04  */

             CLRPFM     FILE(QTEMP/GDGWP77)
             OVRDBF     FILE(GDGWP77) TOFILE(QTEMP/GDGWP77)
             OVRDBF     FILE(GDGWL77) TOFILE(QTEMP/GDGWL77)
             OVRDBF     FILE(GDGWL78) TOFILE(QTEMP/GDGWL78)



             CALL       PGM(GDGR77)


             ENDPGM
