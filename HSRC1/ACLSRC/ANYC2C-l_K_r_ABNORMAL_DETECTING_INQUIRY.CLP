             /** ANYC20 **********************************************/
             /*つるべ生産指示 : ABNORMAL DETECTING INQUIRY         */
             /*                                                      */
             /*  2020.7.23                                           */
             /********************************************************/
             PGM        PARM(&P1SHN1 &P1SHN2 &P1SHN3 &P1MTK1 &P1MTK2 +
                          &P1MTK3 &P1MTK4 &P1TTK1 &P1TTK2 &P1TTK3 +
                          &P1TTK4)
             DCL        VAR(&P1SHN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&P1SHN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&P1SHN3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1MTK1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1MTK2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1MTK3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1MTK4) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1TTK1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1TTK2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1TTK3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1TTK4) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P9CMD)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)

     /*--------------------------*/
     /*    CHECK ENVIRONMENT     */
     /*--------------------------*/
             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CRTDUPOBJ  OBJ(ANYWP21) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AD#WP11) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AD#WL11) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/ANYWP21)
             CLRPFM     FILE(QTEMP/AD#WP11)

             CPYF       FROMFILE(&PLIB/AD#PP15) +
                          TOFILE(QTEMP/AD#WP11) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

             DLCOBJ     OBJ((AD#PP15 *FILE *EXCL))

             OVRDBF     FILE(ANYWP21) TOFILE(QTEMP/ANYWP21)
             OVRDBF     FILE(AD#WL11) TOFILE(QTEMP/AD#WL11)

             CALL       PGM(ANYR2C) PARM(&P1SHN1 &P1SHN2 +
                          &P1SHN3 &P1MTK1 &P1MTK2 &P1MTK3 &P1MTK4 +
                          &P1TTK1 &P1TTK2 &P1TTK3 &P1TTK4 &P9CMD)

             IF         COND(&P9CMD *EQ '12') THEN(DO)
             CALL       PGM(ANYC2D)
             ENDDO

             DLTOVR     FILE(*ALL)

             ENDPGM
