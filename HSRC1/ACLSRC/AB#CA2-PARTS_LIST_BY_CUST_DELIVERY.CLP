             PGM
             /** AB#CA2 ************************/
             /* ..PARTS LIST                   */
             /*                                */
             /**********************************/
             DCL        VAR(&ID)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)

             CRTDUPOBJ  OBJ(AB#WPA2) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WPA2
             OVRDBF     FILE(AB#WPA2) TOFILE(QTEMP/AB#WPA2)

             CALL       PGM(AB#RA2) PARM(&ID)

             IF         COND(&ID  *EQ '9') THEN(GOTO CMDLBL(END))
  /* SELECT PRINTER */
             CALL UTLC79 PARM(&OUTQ)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) RPLUNPRT(*YES) +
                          OUTQ(&OUTQ) FORMTYPE(K6S1)
             CALL       PGM(AB#RA3) PARM(&ID)
             DLTOVR *ALL
   END:

             ENDPGM
