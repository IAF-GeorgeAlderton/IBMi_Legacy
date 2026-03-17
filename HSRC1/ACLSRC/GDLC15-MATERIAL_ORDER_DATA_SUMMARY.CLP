             PGM
             /** GDLC15 *******************************************/
             /*  MATERIAL ORDER DATA CONFIRM PROCESS              */
             /*  A.MAMIYA  2000.12.06                             */
             /*  ---------------------                            */
             /*  TCH57 TCH 06/20/05 ADDED ONCE A DAY REST.        */
             /*  TCHK1 TCH 10/13/05 CHGED ONCE A DAY REST.        */
             /*  TCHK2 TCH 03/18/08 ADDED ONCE A DAY UNLOCK       */
             /*  JW1       01/19/18 ADDED &PLIB &WLIB             */
             /*  JW2       06/20/18 MODIFY DTAARA INFORMATION     */
             /*  JW3       05/24/22 ADD LOG PROGRAM               */
             /*****************************************************/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&P1)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&P2)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBR)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(10)

/*JW2*/      DCL        VAR(&PGM )  TYPE(*CHAR) LEN(10)
/*JW2*/      DCL        VAR(&INF )  TYPE(*CHAR) LEN(50)
/*JW2*/      DCL        VAR(&WS  )  TYPE(*CHAR) LEN(10)
/*JW2*/      DCL        VAR(&PG2 )  TYPE(*CHAR) LEN(10)
/*JW2*/      DCL        VAR(&MSG1)  TYPE(*CHAR) LEN(100)
/*JW2*/      DCL        VAR(&MBR )  TYPE(*CHAR) LEN(10)

/*JW4*/      DCL        VAR(&MSG2)  TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID) USER(&USER) DATE(&DDATE)
/*JW2*/      CHGVAR     VAR(&PGM) VALUE('101 GDLC15')

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)
/*JW2*/      CALL       PGM(UTLR23) PARM(&PGM &INF)

             CHGJOB     SWS(00000000)

             CHKOBJ     OBJ(&PLIB/GDLCACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(SKIP))

/*JW2*/      RTVDTAARA  DTAARA(&PLIB/GDLCACT (1  10)) RTNVAR(&MBR)
/*JW2*/      RTVDTAARA  DTAARA(&PLIB/GDLCACT (31 10)) RTNVAR(&WS )
/*JW2*/      RTVDTAARA  DTAARA(&PLIB/GDLCACT (41 10)) RTNVAR(&PG2)
             CHGVAR     VAR(&MSG1) VALUE(&MBR *BCAT 'IS USING +
                          PROGRAM' *BCAT &PG2 *BCAT 'AT' *BCAT &WS +
                          *TCAT '. (HFILE1/GDLCACT)')
             CALL       PGM(QUILNGTX) PARM(&MSG1 X'00000046' ' ' ' ' +
                          X'00000000')
             GOTO       END2
 SKIP:
             CRTDTAARA  DTAARA(&PLIB/GDLCACT) TYPE(*CHAR) LEN(50) +
                          VALUE(&INF) TEXT('MATERIAL ORDER +
                          PROCESSING') AUT(*ALL)

             CHGVAR     VAR(&P1)    VALUE('1')
             CHGVAR     VAR(&P2)    VALUE(' ')
             CALL       PGM(GDLR98) PARM(&P1 &PSIRE &P2)

             IF         COND(&P2 *EQ '9') THEN(GOTO CMDLBL(END1))

           /* DATA BACKUP */
             IF         COND(&USER *NE 'TEST') THEN(DO)
             CALL       PGM(GDLC1X)
             ENDDO

      /* DATA SUMMARY */
             CALL       PGM(GDLCE0) PARM('1' &PSIRE)

 /*JW4 SAVE LOG UTLWP07D */
             CHGVAR     VAR(&MSG2) VALUE('GDLC15-GDLCE0 : ORD SUMM  XXXX')
             CHGVAR     VAR(%SST(&MSG2 27 4)) VALUE(&PSIRE)
             CALL       PGM(UTLR07D) PARM('GDLC15' &MSG2)
 END1:
             DLTDTAARA  DTAARA(&PLIB/GDLCACT)
             MONMSG     MSGID(CPF2105)

 END2:       ENDPGM
