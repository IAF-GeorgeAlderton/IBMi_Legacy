             PGM        PARM(&IPART)
/** ALDC6Y2************************************************/
/*  #OF SHORTAGE SCAN                                     */
/*  JW   2019.08.21 COPIED FROM ALDC6Y                    */
/*  JW   2019.08.21 ADD PARAMETER FOR PART#               */
/**********************************************************/
             DCL        VAR(&IPART) TYPE(*CHAR) LEN(12)

             DLTF       FILE(QTEMP/ALDWP68)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(ALDWP68) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             OVRDBF     FILE(ALDWP68) TOFILE(QTEMP/ALDWP68)
             CLRPFM     FILE(QTEMP/ALDWP68)

             CALL       PGM(ALDR6Y) PARM(&IPART)

             ENDPGM
