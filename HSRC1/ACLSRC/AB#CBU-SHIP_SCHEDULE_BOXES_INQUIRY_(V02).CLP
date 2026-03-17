             PGM        PARM(&PF)
/** AB#CBT ************************************************/
/*  SHIP/SCHEDULE BOXES INQUIRY (V02)                     */
/*  J.WATANABE    2021.06.16                              */
/**********************************************************/
             DCL        VAR(&PF)   TYPE(*CHAR) LEN(1)

             OVRDBF     FILE(AB#WPAQ)  TOFILE(QTEMP/AB#WPAQ)
             OVRDBF     FILE(AB#WPAT)  TOFILE(QTEMP/AB#WPAT)

             CALL       PGM(AB#RBT1)

             DLTF       FILE(QTEMP/AB#WLAQ)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(AB#WLAQ) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AB#WLAQ)  TOFILE(QTEMP/AB#WLAQ)

             CALL       PGM(AB#RBT) PARM(&PF)

             ENDPGM
