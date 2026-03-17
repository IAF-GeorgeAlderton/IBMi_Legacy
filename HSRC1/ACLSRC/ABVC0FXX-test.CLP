             PGM

             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLAG) TYPE(*CHAR)  LEN(1)
             DCL        VAR(&PERR) TYPE(*CHAR)  LEN(1)

             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')

  /* CREATE WORK FILES  */
             DLTF       FILE(TWFILE1/ABVWP0F)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABVWP0F) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(TWFILE1)
             MONMSG     MSGID(CPF0000)
             CLRPFM TWFILE1/ABVWP0F

             CRTDUPOBJ  OBJ(MITANKF) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(TWFILE1)
             MONMSG     MSGID(CPF0000)
             CLRPFM TWFILE1/MITANKF
             CRTDUPOBJ  OBJ(AB#WP34) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(TWFILE1)
             MONMSG     MSGID(CPF0000)
             CLRPFM TWFILE1/AB#WP34

             CRTDUPOBJ  OBJ(AB#WP33) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(TWFILE1)
             MONMSG     MSGID(CPF0000)
             CLRPFM TWFILE1/AB#WP33

             DLTF       FILE(TWFILE1/AB#WP0G)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AB#WP0G) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(TWFILE1)
             MONMSG     MSGID(CPF0000)
             CLRPFM TWFILE1/AB#WP0G

    /**      CLRPFM     TFILE1/ABVEP51      **/
    /**      CLRPFM     TFILE1/ABVEP52      **/
    /**      CLRPFM     TFILE1/ABVEP53      **/
    /**      CLRPFM     TFILE1/ABVEP54      **/
    /**      CLRPFM     TFILE1/ABVEP55      **/
    /**      CLRPFM     TFILE1/ABVEP56      **/
    /**      CLRPFM     TFILE1/ABVEP57      **/

             OVRDBF     FILE(MITANKF)  TOFILE(TWFILE1/MITANKF)
             OVRDBF     FILE(ABVWP0F)  TOFILE(TWFILE1/ABVWP0F)
             OVRDBF     FILE(AB#WP34)  TOFILE(TWFILE1/AB#WP34)
             OVRDBF     FILE(AB#WP0G)  TOFILE(TWFILE1/AB#WP0G)
             OVRDBF     FILE(ABVEP51)  TOFILE(TFILE1/ABVEP51)
             OVRDBF     FILE(ABVEP52)  TOFILE(TFILE1/ABVEP52)
             OVRDBF     FILE(ABVEP53)  TOFILE(TFILE1/ABVEP53)
             OVRDBF     FILE(ABVEP54)  TOFILE(TFILE1/ABVEP54)
             OVRDBF     FILE(ABVEP55)  TOFILE(TFILE1/ABVEP55)
             OVRDBF     FILE(ABVEP56)  TOFILE(TFILE1/ABVEP56)
             OVRDBF     FILE(ABVEP57)  TOFILE(TFILE1/ABVEP57)
             OVRDBF     FILE(ABVEL57B) TOFILE(TFILE1/ABVEL57B)

             CALL       PGM(ABVR0F) PARM(&FLAG &PERR)

             CPYF       FROMFILE(TFILE1/ABVEP52) +
                          TOFILE(TFILE1/ABVEP51) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2869 CPF2817)

             ENDPGM
