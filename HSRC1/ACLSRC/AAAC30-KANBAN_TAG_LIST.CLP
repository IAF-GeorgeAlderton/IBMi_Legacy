             PGM
             /** AAAC30 ************************/
             /* KANBA TAG LIST                 */
             /* TCH 2000.07.31                 */
             /************************ AAAC30 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER)

             CLRPFM     FILE(AAAWP30)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(AAAR30) PARM(&USER)

             CALL       PGM(AAAR31) PARM(&USER)

             ENDPGM
