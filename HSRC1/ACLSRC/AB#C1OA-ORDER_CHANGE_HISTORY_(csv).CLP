             PGM
             /***AB#C1OA ******************************************/
             /* ORDER CHANGE HISTORY (2 LINES) (CSV)              */
             /* JW    2023.06.07                                  */
             /*****************************************************/
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)

 /* SET AB#WP1K */
             DLTF       FILE(QTEMP/AB#WP1K)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ OBJ(AB#WP1K) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             CLRPFM     QTEMP/AB#WP1K

             OVRDBF     FILE(AB#WP1K ) TOFILE(QTEMP/AB#WP1K)

 /* CONVERT AB#WP1H TO AB#WP1K */
             CALL       PGM(AB#R1OA)

 /* TRANSFER TO CSV */
             CHGVAR   VAR(&FNAM) VALUE('ORDER CHG LOG')
             CALL     PGM(APLC94) PARM('2' 'AB#WP1K' 'HWFILE1' &FNAM 'Y' '' 'Y')

             ENDPGM
