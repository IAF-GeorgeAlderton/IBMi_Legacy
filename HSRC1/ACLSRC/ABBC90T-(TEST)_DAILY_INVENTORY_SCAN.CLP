             PGM
             /** ABBC91 *****************************************/
             /*  DAILY INVENTORY SCAN                           */
             /*                                                 */
             /***************************************** ABBC91 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             ADDLIBLE   LIB(TWFILE1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TFILE1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(HOBJ1)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(ABBR90)
             SIGNOFF

             ENDPGM
