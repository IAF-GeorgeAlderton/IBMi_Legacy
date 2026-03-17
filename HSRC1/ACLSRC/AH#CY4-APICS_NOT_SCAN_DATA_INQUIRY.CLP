             PGM        PARM(&WLIB &AH#WPY1)
             /** AH#CY3 **************************************/
             /*  APICS NOT SCAN DATA INQUIRY                 */
             /*  J.W   2017.12.06                            */
             /************************************************/
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&AH#WPY1) TYPE(*CHAR) LEN(10)

 /*1 SET WORK FILE IN QTEMP */
             DLTF       FILE(QTEMP/AH#WPY1)
             MONMSG     MSGID(CPF2105)
             CRTDUPOBJ  OBJ(AH#WPY1) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(&WLIB/&AH#WPY1) +
                          TOFILE(QTEMP/AH#WPY1) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2869 CPF2817)
             OVRDBF     FILE(AH#WPY1) TOFILE(QTEMP/AH#WPY1)
 /*1 */
             CALL       PGM(AH#RY4)

        /**  DLTOVR     FILE(#ALL)  **/

             ENDPGM
