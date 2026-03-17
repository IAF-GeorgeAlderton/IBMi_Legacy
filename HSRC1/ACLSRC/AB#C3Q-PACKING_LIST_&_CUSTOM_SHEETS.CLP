             PGM
/** AB#C3Q ************************************************/
/*    PACKING LIST & CUSTOM SHEETS                        */
/*                                                        */
/* TCHK1 11/13/06 ADD NEW FILE                            */
/* TCHK2 12/06/06 CHG &WSID LENGTH                        */
/* TCHK3 12/14/12 ADD NEW FILE FOR ACZ PROCESS            */
/* %0001 03/09/18 CHECK ENVIRONMENT         T.SAKAKI      */
/* %0002 04/02/18 ADD AB#WP37                             */
/*       10/18/19 ADD ABWPL38                             */
/* JW1 2023.01.12 ADD UEXR90A                             */
/********************************************** AB#C3Q ****/
/* TCHK2 */  DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
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
             CRTDUPOBJ  OBJ(ABWPL33) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABWPL34) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABWPL36) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
/* TCHK1 */  CRTDUPOBJ  OBJ(ABWPL37) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
/* TCHK1 */  MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABWPL38) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM QTEMP/ABWPP31

             CRTDUPOBJ  OBJ(ABWPP3W) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABWPL3W) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABWPP3W
/* TCHK3 */  CRTDUPOBJ  OBJ(ABWPP38) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
/* TCHK3 */  CLRPFM QTEMP/ABWPP38

/* %0002 */
             CRTDUPOBJ  OBJ(AB#WP37) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP37

             OVRDBF     FILE(ABWPP3W) TOFILE(QTEMP/ABWPP3W)
             OVRDBF     FILE(ABWPL3W) TOFILE(QTEMP/ABWPL3W)
             OVRDBF     FILE(AB#PP31) TOFILE(QTEMP/ABWPP31)
             OVRDBF     FILE(AB#PL31) TOFILE(QTEMP/ABWPL31)
             OVRDBF     FILE(AB#PL32) TOFILE(QTEMP/ABWPL32)
             OVRDBF     FILE(AB#PL33) TOFILE(QTEMP/ABWPL33)
             OVRDBF     FILE(AB#PL34) TOFILE(QTEMP/ABWPL34)
/* TCHK1 */  OVRDBF     FILE(AB#PL37) TOFILE(QTEMP/ABWPL37)
             OVRDBF     FILE(ABWPL33) TOFILE(QTEMP/ABWPL33)
             OVRDBF     FILE(ABWPL36) TOFILE(QTEMP/ABWPL33)
/* TCHK3 */  OVRDBF     FILE(ABWPP38) TOFILE(QTEMP/ABWPP38)
/* %0002 */  OVRDBF     FILE(AB#WP37) TOFILE(QTEMP/AB#WP37)
             OVRDBF     FILE(ABWPL38) TOFILE(QTEMP/ABWPL38)

             CHKOBJ     OBJ(AB#WP60) OBJTYPE(*FILE) MBR(&WSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM +
                          FILE(AB#WP60) MBR(&WSID))

             CLRPFM     FILE(AB#WP60) MBR(&WSID)

             OVRDBF     FILE(AB#WP60) TOFILE(AB#WP60) MBR(&WSID)
             CALL       PGM(AB#R3Q)

 /* SAVE AB#WP37 --> AB#PP37S */
             CALL       PGM(EDSR03)

  /** JW1 SET PACKING LIST# IN AB#PP10 **/
             CALL       PGM(UEXR90A) PARM('Y')
             CALL       PGM(UEXR90B) PARM(' ')

             DLTOVR     FILE(*ALL)

             ENDPGM
