             PGM
             /** GDLC05 ***********************************/
             /*  MATERIAL ORDER DATA UPDATE SYSTEM        */
             /*               K.YASUDA  2000.08.08        */
             /*                                           */
             /*  TCHK1 03/18/08 ADD USER EXISTING CHECK   */
             /*  JW1   06/20/18 MODIFY DTAARA INFORMATION */
             /*********************************** GDLC05 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

/*JW1*/      DCL        VAR(&PGM )  TYPE(*CHAR) LEN(10)
/*JW1*/      DCL        VAR(&INF )  TYPE(*CHAR) LEN(50)
/*JW1*/      DCL        VAR(&WS  )  TYPE(*CHAR) LEN(10)
/*JW1*/      DCL        VAR(&PG2 )  TYPE(*CHAR) LEN(10)
/*JW1*/      DCL        VAR(&MBR )  TYPE(*CHAR) LEN(10)
/*JW1*/      DCL        VAR(&MSG1)  TYPE(*CHAR) LEN(100)

             RTVJOBA    JOB(&WSID) USER(&USER)
/*JW1*/      CHGVAR     VAR(&PGM) VALUE('102 GDLC05')
/*JW1*/      CALL       PGM(UTLR23) PARM(&PGM &INF)

/* TCHK1 S */
             CHKOBJ     OBJ(HFILE1/GDLCACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(SKIP))

        /*   CHGVAR     VAR(&MSGX) VALUE('IS USING THIS +             */
        /*                PROGRAM.(GDLCACT)')                         */
        /*   RTVDTAARA  DTAARA(HFILE1/GDLCACT (1 10)) RTNVAR(&SMB)    */
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
             CRTDTAARA  DTAARA(HFILE1/GDLCACT) TYPE(*CHAR) LEN(50) +
                          VALUE(&INF ) TEXT('MATERIAL ORDER +
                          PROCESSING') AUT(*ALL)
/* TCHK1 E */

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(GDLR05) PARM(&USER)

/* TCHK1 S */
 END1:
             DLTDTAARA  DTAARA(HFILE1/GDLCACT)
             MONMSG     MSGID(CPF2105)

 END2:
/* TCHK1 E */

             ENDPGM
