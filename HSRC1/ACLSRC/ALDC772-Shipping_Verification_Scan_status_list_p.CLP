  PGM PARM(&STDT &EDDT &LIST2 &LIST3 &LIST4)
/** ALDC77 *************************************************/
/*  SHIPPING VERIFICATION SCAN STATUS LIST                 */
/*                                                         */
/* TCHK1 03/12/10 CREATE                                   */
/***********************************************************/
             DCL        VAR(&STDT)     TYPE(*CHAR) LEN(08)
             DCL        VAR(&EDDT)     TYPE(*CHAR) LEN(08)
             DCL        VAR(&LIST2)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&LIST3)    TYPE(*CHAR) LEN(01)
             DCL        VAR(&LIST4)    TYPE(*CHAR) LEN(01)

/* STATUS LIST */
             CRTDUPOBJ  OBJ(ALDWP772) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ALDWL772) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/ALDWP772

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT06) FORMTYPE(K6S1)

             OVRDBF     FILE(ALDWP772) TOFILE(QTEMP/ALDWP772)
             OVRDBF     FILE(ALDWL772) TOFILE(QTEMP/ALDWL772)

             CALL       PGM(ALDR772)   PARM(&STDT +
                                            &EDDT +
                                            &LIST2 +
                                            &LIST3 +
                                            &LIST4 )

             DLTOVR     FILE(QPRINT)


             ENDPGM
