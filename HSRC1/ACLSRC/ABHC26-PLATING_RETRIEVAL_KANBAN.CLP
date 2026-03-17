             PGM
             /** AHBC26 ************************************************/
             /*  PLATING RETRIEVAL KANBAN ISSUE                        */
             /**********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CHK) TYPE(*CHAR) LEN(1)

             DCL        VAR(&JPGM )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JINF )  TYPE(*CHAR) LEN(50)
             DCL        VAR(&JMBR )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JWS  )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JPGM )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JMSG )  TYPE(*CHAR) LEN(100)
             CHGVAR     VAR(&JPGM)   VALUE('ABHC26')
             CALL       PGM(UTLR23)  PARM(&JPGM &JINF)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             CHGJOB     OUTQ(&PRTG)
             CHGJOB     SWS(00000000)

 /* INTRA-PROCESS KANBAN REISSUE PROGRAM OPERATION CHECK */
             CHKOBJ     OBJ(&WLIB/ABHACT3) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STPA))

 STP1:

/* DISPLAY ERROR & END JOB (JW1) */
             RTVDTAARA  DTAARA(&WLIB/ABHACT3 (1  10)) RTNVAR(&JMBR)
             RTVDTAARA  DTAARA(&WLIB/ABHACT3 (31 10)) RTNVAR(&JWS )
             RTVDTAARA  DTAARA(&WLIB/ABHACT3 (41 10)) RTNVAR(&JPGM)
             CHGVAR     VAR(&JMSG) VALUE(&JMBR *BCAT 'IS USING THIS +
                          PROGRAM AT' *BCAT &JWS *TCAT '. (' *BCAT +
                          &WLIB *BCAT '/ ABHACT3 )')
             CALL       PGM(QUILNGTX) PARM(&JMSG X'00000046' ' ' ' ' +
                          X'00000000')
             GOTO       END

 STPA:       CRTDTAARA  DTAARA(&WLIB/ABHACT3) TYPE(*CHAR) LEN(50) +
                          VALUE(&JINF) TEXT('PLATING RETRIEVAL +
                          KANBAN ISSUE SYSTEM IS ACTIVE') AUT(*ALL)

 /* PLATING RETRIEVAL KANBAN ISSUE WORK-FILE CREATE */
             CHKOBJ     OBJ(&WLIB/ABHWPIB) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801)  EXEC(DO)
             CRTPF      FILE(&WLIB/ABHWPIB) RCDLEN(1024) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO) +
                          AUT(*ALL) /* KANBAN REISSUE WORK <ENA +
                          FACTORY> */
             ENDDO


 /* KANBAN DATA MAKING */
             CALL       PGM(ABHR26) PARM(&CHK)
             DLTDTAARA  DTAARA(&WLIB/ABHACT3)

 END:        ENDPGM
