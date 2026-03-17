             PGM        PARM(&PSIRE &XSPL &MSG)
/** SPLC11 *****************************************************************/
/*  OUTPUT SPOOL(CUSTOM SHEET) TO DIRECTORY BY PDF                         */
/*  J.W    2023.02.28                                                      */
/*-----------------------------------------------                          */
/*  Paramete                                                               */
/*  &PSIRE (4A) = Delivery Code e                                          */
/*  &XSPL  (8A) = Spool File Name                                          */
/*  &MSG   (1A) = Y: Pop up break Message                                  */
/*              = N: Do not Pop up Message                                 */
/***************************************************************************/
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(04)
             DCL        VAR(&XSPL)  TYPE(*CHAR) LEN(08)
             DCL        VAR(&MSG )  TYPE(*CHAR) LEN(01)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN( 6)
             DCL        VAR(&DIRA)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIRB)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR1)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIRN)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(35)

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DAT10) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

    /* DATE      */
             CALL       EDTR01A ('' 'YMD' '.' &DAT10)

    /* FILE NAME */
             CHGVAR   VAR(&FNAM  ) VALUE('DOCUMENT.pdf')
             IF         COND(&XSPL = 'QPRINT  ') THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('CUSTOM SHEET' *BCAT &PSIRE +
                          *BCAT &DAT10 *TCAT '.pdf')
             ENDDO

    /* GET DIRECTORY */
             CALL       SPLC80 PARM(&USER &DIRA &DIRB)
             CHGVAR     VAR(&DIR1  ) VALUE(&DIRA *TCAT &FNAM)
             CHGVAR     VAR(&DIR2  ) VALUE(&DIRB *TCAT &FNAM)

    /* OUT PDF     */
             RMVLNK     OBJLNK(&DIR1)
             MONMSG     MSGID(CPFA0D4 CPFA0A9)

             CPYSPLF    FILE(&XSPL) TOFILE(*TOSTMF) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST) +
                          TOSTMF(&DIR1) WSCST(*PDF) STMFOPT(*REPLACE)

             MONMSG     MSGID(CPF3303 CPA0701) EXEC(GOTO CMDLBL(ERR1))

    /* END MESSAGE */
             IF         COND(&MSG *EQ 'Y') THEN(DO)
             SNDBRKMSG  MSG('REPORT HAS BEEN CREATED IN YOUR USER +
                          DIRECTORY' *BCAT &DIR2) TOMSGQ(&WSID)
             GOTO       CMDLBL(ENDP)
             ENDDO
             IF         COND(&MSG *EQ 'N') THEN(GOTO ENDP)

 ERR1:       SNDBRKMSG  MSG('** ERROR ** REPORT DID NOT CREATED. +
                          PLEASE SEE IT DEPARTMENT.') TOMSGQ(&WSID)
             GOTO       CMDLBL(ENDP)

ENDP:        ENDPGM
