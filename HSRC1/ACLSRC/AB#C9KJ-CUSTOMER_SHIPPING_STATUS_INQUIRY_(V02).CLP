             PGM
/*= AB#C9K ===============================================*/
/*  PROGRAM    : CUSTOMER SHIPPING STATUS INQUIRY (V03)   */
/*  WRITTEN    : 2021/06/25  BY JW                        */
/*========================================================*/

             CRTDUPOBJ  OBJ(AB#WP98) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AB#WP09)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WP09) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WP09)

             OVRDBF     FILE(AB#WP09) TOFILE(QTEMP/AB#WP09)
             OVRDBF     FILE(AB#WP98) TOFILE(QTEMP/AB#WP98)

/* JW1 ***** CALL       PGM(AB#R983) ***** */
/* JW2 ***** CALL       PGM(AB#R984) ***** */
/* JW3 ***** CALL       PGM(AB#R986) ***** */
/* JW4 ***** CALL       PGM(AB#R987) ***** */
/* JW  ***** CALL       PGM(AB#R988) ***** */
/* JW  ***** CALL       PGM(AB#R989) ***** */
             CALL       PGM(AB#R98B)

             DLTOVR     FILE(*ALL)

             ENDPGM
