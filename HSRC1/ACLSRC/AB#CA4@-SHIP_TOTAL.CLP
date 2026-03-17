             PGM
             /** AB#CA4 ************************/
             /* ..SHIP TOTAL                   */
             /*                                */
             /**********************************/
             DCL        VAR(&ID)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&YY)  TYPE(*DEC) LEN(4 0)
             DCL        VAR(&MM)  TYPE(*DEC) LEN(2 0)

             CRTDUPOBJ  OBJ(AB#WPA4) FROMLIB(TWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WPA4
             OVRDBF     FILE(AB#WPA4) TOFILE(QTEMP/AB#WPA4)

             CALL       PGM(AB#RA4) PARM(&ID &YY &MM)

             IF         COND(&ID  *EQ '9') THEN(GOTO CMDLBL(END))

             CALL       PGM(AB#RA5) PARM(&YY &MM)
             DLTOVR *ALL
   END:

             ENDPGM
