             PGM
             /** GDLC1A **********************************/
             /*  MATERIAL ORDER SHEET PRINT CONTROL      */
             /*                                          */
             /*  TCHK1  10/14/05 CREATE(COPY FROM GDLC10 */
             /*  TCHK2  01/01/08 CHG 0002 TO 8990        */
             /*  JW     12/22/17 ADD 4530 (NSCI)         */
             /*         01/22/18 USE &PLIB               */
             /*  JW1   06/20/18 MODIFY DTAARA INFORMATION*/
             /*  JW2   09/01/20 ADD 4540 (CHARTER STEEL) */
             /*  JW3   12/23/20 ADD 4550 (POSCO)         */
             /*  JW3   01/04/21 ADD 4560 (TSUSHO)        */
             /*  JW4   05/24/22 ADD LOG PROGRAM          */
             /********************************** GDLC1A **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&P1)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&P2)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(46)
             DCL        VAR(&MSGX)  TYPE(*CHAR) LEN(35)
             DCL        VAR(&SMB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(10)

/*JW1*/      DCL        VAR(&PGM )  TYPE(*CHAR) LEN(10)
/*JW1*/      DCL        VAR(&INF )  TYPE(*CHAR) LEN(50)
/*JW1*/      DCL        VAR(&WS  )  TYPE(*CHAR) LEN(10)
/*JW1*/      DCL        VAR(&PG2 )  TYPE(*CHAR) LEN(10)
/*JW1*/      DCL        VAR(&MBR )  TYPE(*CHAR) LEN(10)
/*JW1*/      DCL        VAR(&MSG1)  TYPE(*CHAR) LEN(100)

/*J41*/      DCL        VAR(&MSG2)  TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)
/*JW1*/      CHGVAR     VAR(&PGM) VALUE('103 GDLC1A')
/*JW1*/      CALL       PGM(UTLR23) PARM(&PGM &INF)

             CHGJOB     SWS(00000000)

             CHKOBJ     OBJ(&PLIB/GDLCACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(SKIP))

        /*   CHGVAR     VAR(&MSGX) VALUE('IS USING THIS +             */
        /*                PROGRAM.(GDLCACT)')                         */
        /*   RTVDTAARA  DTAARA(&PLIB/GDLCACT (1 10)) RTNVAR(&SMB)     */
        /*   CHGVAR     VAR(&MSG) VALUE(&SMB *CAT &MSGX)              */
        /*   CALL       PGM(QUILNGTX) PARM(&MSG X'00000046' '       + */
        /*                ' '                    ' X'00000000')       */
        /*   GOTO       END2                                          */

/*JW1*/      RTVDTAARA  DTAARA(HFILE1/GDLCACT (1  10)) RTNVAR(&MBR)
             RTVDTAARA  DTAARA(HFILE1/GDLCACT (31 10)) RTNVAR(&WS )
             RTVDTAARA  DTAARA(HFILE1/GDLCACT (41 10)) RTNVAR(&PG2)
             CHGVAR     VAR(&MSG1) VALUE(&MBR *BCAT 'IS USING +
                          PROGRAM' *BCAT &PG2 *BCAT 'AT' *BCAT &WS +
                          *TCAT '. (HFILE1/GDLCACT)')
             CALL       PGM(QUILNGTX) PARM(&MSG1 X'00000046' ' ' ' ' +
                          X'00000000')
             GOTO       END2
 SKIP:
             CRTDTAARA  DTAARA(&PLIB/GDLCACT) TYPE(*CHAR) LEN(50) +
                          VALUE(&INF ) TEXT('MATERIAL ORDER +
                          PROCESSING') AUT(*ALL)

             CHGVAR     VAR(&P1)    VALUE('2')
             CHGVAR     VAR(&P2)    VALUE(' ')
             CALL       PGM(GDLR98) PARM(&P1 &PSIRE &P2)

             IF         COND(&P2 *EQ '9') THEN(GOTO CMDLBL(END1))

 /* ASJ PROCESS */
 /* TCHK2 */ IF         COND(&PSIRE *EQ '8990') THEN(DO)
                        CALL PGM(GDLC10)
             ENDDO
 /* O&K PROCESS */
             IF         COND(&PSIRE *EQ '4511') THEN(DO)
                        CALL PGM(GDLC1B)
             ENDDO

 /* JW1 NSCI    */
             IF         COND(&PSIRE *EQ '4530') THEN(DO)
                        CALL PGM(GDLC2B)
             ENDDO

 /* JW2 CHARTER */
             IF         COND(&PSIRE *EQ '4540') THEN(DO)
                        CALL PGM(GDLC3B)
             ENDDO

 /* JW3 POSCO   */
             IF         COND(&PSIRE *EQ '4550') THEN(DO)
                        CALL PGM(GDLC4B)
             ENDDO

 /* JW3 TOYOTA TSUSHO */
             IF         COND(&PSIRE *EQ '4560') THEN(DO)
                        CALL PGM(GDLC5B)
             ENDDO

 /*JW4 SAVE LOG UTLWP07D  */
             CHGVAR     VAR(&MSG2) VALUE('GDLC1A-GDLCXB : ORD SHEET XXXX')
             CHGVAR     VAR(%SST(&MSG2 27 4)) VALUE(&PSIRE)
             CALL       PGM(UTLR07D) PARM('GDLC1A' &MSG2)

 END1:
             DLTDTAARA  DTAARA(&PLIB/GDLCACT)
             MONMSG     MSGID(CPF2105)

 END2:
             ENDPGM
