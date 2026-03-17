             PGM
/** AB#C3U ************************************************/
/*    HONDA PACKING LIST & CUSTOM SHEETS                  */
/* %0001 04/18/18 CHECK ENVIRONMENT         T.SAKAKI      */
/* %0002 04/18/18 ADD AB#WP37                             */
/* JW1 2023.01.12 ADD UEXR90A                             */
/********************************************** AB#C3U ****/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(3)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&JOB) USER(&USER)
             CHGVAR     VAR(&WSID) VALUE(%SUBSTRING(&JOB 1 3))

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
             CLRPFM QTEMP/ABWPP31

             CRTDUPOBJ  OBJ(ABWPP3X) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABWPP3X

/* %0002 */
             CRTDUPOBJ  OBJ(AB#WP37) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP37

             OVRDBF     FILE(ABWPP3X) TOFILE(QTEMP/ABWPP3X)
             OVRDBF     FILE(AB#PP31) TOFILE(QTEMP/ABWPP31)
             OVRDBF     FILE(AB#PL31) TOFILE(QTEMP/ABWPL31)
             OVRDBF     FILE(AB#PL32) TOFILE(QTEMP/ABWPL32)
             OVRDBF     FILE(AB#PL33) TOFILE(QTEMP/ABWPL33)
             OVRDBF     FILE(ABWPL33) TOFILE(QTEMP/ABWPL33)
/* %0002 */  OVRDBF     FILE(AB#WP37) TOFILE(QTEMP/AB#WP37)

             CHKOBJ     OBJ(AB#WP60) OBJTYPE(*FILE) MBR(&WSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM +
                          FILE(AB#WP60) MBR(&WSID))

             CLRPFM     FILE(AB#WP60) MBR(&WSID)

             OVRDBF     FILE(AB#WP60) TOFILE(AB#WP60) MBR(&WSID)
             CALL       PGM(AB#R3U)

  /* SAVE AB#WP37 */
               CALL       PGM(EDSR03)
             DLTOVR     FILE(*ALL)

  /** JW1 SET PACKING LIST# IN AB#PP10 **/
             CALL       PGM(UEXR90A) PARM('Y')

             ENDPGM
