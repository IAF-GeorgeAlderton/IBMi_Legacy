             PGM
             /** ECQC30  **************************************/
             /* HIGHEST USAGE TOOLS BY CATEGORY               */
             /*                                               */
             /*                                               */
             /*************************************** ECQC30 **/
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USR)

             CALL       PGM(ALBC00) PARM(&USR &WLIB)

             CRTDUPOBJ  OBJ(ECQWP30) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ECQWP30

             OVRDBF     FILE(ECQWP30) TOFILE(QTEMP/ECQWP30)
             OVRPRTF    FILE(QPRINT) OUTQ(QPRINTC) FORMTYPE(K6H1)
             CALL       PGM(ECQR30)
             DLTOVR *ALL

             ENDPGM
