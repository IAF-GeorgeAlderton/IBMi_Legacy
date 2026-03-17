             PGM        PARM(&PF)
/** AB#CAO ************************************************/
/*  SHIP/SCHEDULE BOXES INQ BY MACHINE                    */
/*  J.WATANABE    2021.03.15                              */
/**********************************************************/
             DCL        VAR(&PF)   TYPE(*CHAR) LEN(1)

/* ADJUST AB#WPAO */
             DLTF       FILE(QTEMP/AB#WLAO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AB#WLAO) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AB#WLAO2)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AB#WLAO2) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AB#WLAO)  TOFILE(QTEMP/AB#WLAO )
             OVRDBF     FILE(AB#WLAO2) TOFILE(QTEMP/AB#WLAO2)

             CALL       PGM(AB#RAO1)

 /* CREATE AB#WPAO2 (SCREEN DATA) */

             DLTF       FILE(QTEMP/AB#WPAO2)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AB#WPAO2) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AB#WPAO2) TOFILE(QTEMP/AB#WPAO2)

             CALL       PGM(AB#RAO2)

 /* DISPLAY AB#WPAO2 */
             CALL       PGM(AB#RAO) PARM(&PF)

             ENDPGM
