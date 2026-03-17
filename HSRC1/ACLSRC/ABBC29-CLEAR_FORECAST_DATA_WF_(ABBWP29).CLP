             PGM
             /** ABBC29 ********************************/
             /*  CLEAR FORECAST DATA WF (ABBWP29)      */
             /*  JW    2018.11.02                      */
             /******************************************/

             CHKOBJ     OBJ(QTEMP/ABBWP29) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTDUPOBJ OBJ(ABBWP29) +
                          FROMLIB(*LIBL) OBJTYPE(*FILE) TOLIB(QTEMP))

             CLRPFM     FILE(QTEMP/ABBWP29)

             ENDPGM
