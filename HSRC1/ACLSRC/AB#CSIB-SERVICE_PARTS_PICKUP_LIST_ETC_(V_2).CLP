             PGM
             /** AB#CSI **********************************************/
             /*  SERVICE PARTS PICK UP LIST                          */
             /*                                       ???????        */
             /* %0001  T.SAKAKI    06/07/18 ADD AB#WP37              */
             /********************************************** AB#CSI **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)
     /*--------------------------*/
     /*    CHECK ENVIRONMENT     */
     /*--------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)


             CRTDUPOBJ  OBJ(ABWPP31) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABWPL31) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABWPL32) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABWPP31

             CRTDUPOBJ  OBJ(ABWPP3W) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABWPL35) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABWPP3W
    /* %0001 */
             CRTDUPOBJ  OBJ(AB#WP37) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP37


             OVRDBF     FILE(ABWPP3W) TOFILE(QTEMP/ABWPP3W)
             OVRDBF     FILE(AB#PP31) TOFILE(QTEMP/ABWPP31)
             OVRDBF     FILE(AB#PL31) TOFILE(QTEMP/ABWPL31)
             OVRDBF     FILE(AB#PL32) TOFILE(QTEMP/ABWPL32)
             OVRDBF     FILE(ABWPL35) TOFILE(QTEMP/ABWPL35)
/* %0001 */  OVRDBF     FILE(AB#WP37) TOFILE(QTEMP/AB#WP37)

             CALL       PGM(AB#RSIB)

             DLTOVR     FILE(*ALL)

             ENDPGM
