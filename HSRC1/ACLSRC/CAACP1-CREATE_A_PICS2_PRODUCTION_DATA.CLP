             PGM
             /** CAACP1 ************************************/
             /*  A-PICS2 PRODUCTION DATA CREATE        ..  */
             /*       T-SAKAKI             2020.08.19      */
             /************************************ CAACP1 **/
             DCLF       FILE(CAAPWP1)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PCK1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCK2) TYPE(*CHAR) LEN(1)

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HSRC1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)

    /********************************/
    /* CHECK LIBRARY                */
    /********************************/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

    /********************************/
    /* CHECK UNLOCK MANAGEMENT      */
    /********************************/
             CHGVAR     VAR(&IN55) VALUE('0')

             CHKOBJ     OBJ(&PLIB/CAAACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STPX))
 STPY:
             CHGVAR     VAR(&IN55) VALUE('1')
 STPX:
             CHGVAR     VAR(&PHS) VALUE('0000')

    /********************************/
    /* CALENDER CHECK               */
    /********************************/
             CALL       PGM(CAARF1) PARM('A' &PCK1)
             IF         (&PCK1 *EQ '0') DO
             CHGVAR     VAR(&IN98) VALUE('1')
             ENDDO

             CALL       PGM(CAARF1) PARM('B' &PCK2)
             IF         (&PCK2 *EQ '1') DO
             CHGVAR     VAR(&PHS) VALUE('0800')
             ENDDO

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(CAAPWP11)

             IF         (&IN01 *EQ '1') DO
             GOTO       END
             ENDDO


      /* UNLOCK */
             IF         (&IN12 *EQ '1') DO
             DLTDTAARA  DTAARA(&PLIB/CAAACT)
             MONMSG     MSGID(CPF2105)
             CHGVAR     VAR(&IN55) VALUE('0')
             GOTO       STP1
             ENDDO

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (%SST(&PHS 3 2) *NE '00') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('FOR SPECIFIED TIME, MINUTES +
                          OTHER THAN 00 CANNOT BE SPECIFIED.')
             GOTO       STP1
             ENDDO

             IF         (&PCK1 *EQ '0') DO
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THIS SYSTEM CANNOT BE +
                          EXECUTED.')
             GOTO       STP1
             ENDDO

             IF         COND(&IN05 *EQ '0' *OR &IN55 *EQ '1') +
                          THEN(GOTO CMDLBL(STP1))

             CRTDTAARA  DTAARA(&PLIB/CAAACT) TYPE(*CHAR) LEN(10) +
                          TEXT('A-PICS2 PRODUCTION-INSTRUCTION DATA +
                          CREATION') AUT(*ALL)

             CHGVAR     VAR(&HSRC1) VALUE('HSRC1     ')
             CHGVAR     VAR(&PDEVT) VALUE('*SCS  ')
             CHGVAR     VAR(&PIGCD) VALUE('*YES')
             CHGVAR     VAR(&PRTG) VALUE('SAKAKI    ')

     /** STOP FOR TEST **/
             SBMJOB     CMD(CALL PGM(CAACJ1) PARM(&WSID &USER &PHS +
                          &HSRC1 &PLIB &WLIB &PDEVT +
                          &PIGCD &PRTG)) JOB(APICS2) JOBD(QBATCH3) +
                          JOBQ(JOBQ3)

             GOTO       CMDLBL(END)

             CALL       PGM(CAACJ1) PARM(&WSID &USER &PHS &HSRC1 +
                          &PLIB &WLIB &PDEVT &PIGCD &PRTG)

 END:        ENDPGM
