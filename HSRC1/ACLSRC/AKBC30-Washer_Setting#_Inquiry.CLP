/** AKBC30 ************************************************/
/*  WASHER SETTING# INQUIRY                               */
/*                                                        */
/* TCHK  09/02/11 CREATE                                  */
/**********************************************************/
   PGM
             DCL        VAR(&P1SUPP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
 STP1:
             CALL       PGM(HOBJ1/AKBR31) PARM(&P1SUPP &PCMD)
             IF         COND(&PCMD *EQ '03') THEN(GOTO CMDLBL(#END))

             CRTDUPOBJ  OBJ(AKBWP30) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AKBWP31) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AKBWP30)
             CLRPFM     FILE(QTEMP/AKBWP31)

             OVRDBF     FILE(AKBWP30) TOFILE(QTEMP/AKBWP30)
             OVRDBF     FILE(AKBWP31) TOFILE(QTEMP/AKBWP31)

             CALL       PGM(HOBJ1/AKBR30) PARM(&P1SUPP)

             DLTOVR     FILE(*ALL)
             GOTO       CMDLBL(STP1)

 #END:
             ENDPGM
