             PGM
             /** BSDCD2 **************************************/
             /*UNLOCK DATA AREA                            */
             /*        T.SAKAKI        2015.10.13            */
             /************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAR) TYPE(*CHAR) LEN(13)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&DTAR) VALUE('ALD' *CAT &WSID)

 /*CHECK DATA AREA */
 @STEP00:
             CHKOBJ     OBJ(&WLIB/&DTAR) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@END))
 /*DELETE DATA AREA */
 @STEP01:
             DLTDTAARA  DTAARA(&WLIB/&DTAR)
 @END:
             ENDPGM
