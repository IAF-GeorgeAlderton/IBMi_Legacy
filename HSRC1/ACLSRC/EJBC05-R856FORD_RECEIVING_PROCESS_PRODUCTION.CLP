             PGM        PARM(&MSG0 &MSG1 &MSG2)
             /** EJBC05 ***********************************/
             /* R856FORD  RECEIVING PROCESS <PRODUCTION>  */
             /* THIS IS AUTOMATICALLY PROCESSED BY HULFT  */
             /*    T.SAKAKI                   2017.02.08  */
             /*********************************** EJBC05 **/
             DCL        VAR(&MSG0) TYPE(*CHAR) LEN(50)   /* IAF-HULFT */
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(50)   /* R856 */
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(50)   /* FORD______ */
             DCL        VAR(&HOST) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MKBN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PTNR) TYPE(*CHAR) LEN(12)
             DCL        VAR(&NULL) TYPE(*CHAR) LEN(1) VALUE(X'00')
             DCL        VAR(&JYKB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DKB) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POWSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PTTL)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&LEN) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&COUT)   TYPE(*DEC)  LEN(3)
             DCL        VAR(&PJBFLG) TYPE(*CHAR) LEN(1) VALUE(' ')

             DCL        VAR(&PGM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGD)  TYPE(*CHAR) LEN(256)

        /* PROGRAM NAME */
             OVRPRTF QPPGMDMP QSYS/QDARCDSP
             DMPCLPGM
             MONMSG     MSGID(CPF0570) EXEC(DO)
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGD)
             CHGVAR     VAR(&PGM) VALUE(%SST(&MSGD 1 10))
             ENDDO

             CHGVAR     VAR(&PIPGMN) VALUE(&PGM)
             CHGVAR     VAR(&HOST) VALUE(&MSG0 *TCAT &NULL)
             CHGVAR     VAR(&MKBN) VALUE(&MSG1 *TCAT &NULL)
             CHGVAR     VAR(&PTNR) VALUE(&MSG2 *TCAT &NULL)

             CHGVAR     VAR(&SFILE) VALUE('EJBWP05   ')
             CHGVAR     VAR(&SLIBL) VALUE('HWFILE1   ')

             CHGVAR     VAR(&DKB) VALUE(%SST(&MKBN 2 3))

     /*-----------------------------------*/
     /* CHECK PREVIOUS JOB IS DONE OR NOT */
     /*-----------------------------------*/
             CHGVAR     VAR(&COUT) VALUE(30)
             CALL       PGM(EJKC70) PARM(&PIPGMN &COUT &PJBFLG)

             IF         COND(&PJBFLG *EQ '2') THEN(DO)
             CHGVAR     VAR(&PTTL) VALUE('HULFT_RCV GOT AN ERROR +
                          AT ' *CAT &PIPGMN)
             CHGVAR     VAR(&PMSG) VALUE('HULFT_RCV WAS FAILED WHEN +
                          RECEIVING ' *CAT &MKBN *TCAT &PTNR *CAT ' +
                          FROM ' *CAT &HOST *CAT ' PLEAESE CHECK +
                          THE SERVER AND  UNLOCK MULTIPLE PROCESS +
                          CONTROL BY menu #56 in QPGMR, and then +
                          receive the data again ')
        /* NOTIFICATION BY E-MAIL */
             CALL       PGM(MSGC10) PARM(&PTTL &PMSG)
             GOTO       CMDLBL(END2)
             ENDDO


        /* RECORD COUNT */
             RTVMBRD    FILE(&SLIBL/&SFILE) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(@END))

        /*--------------------------------*/
        /* GET PARAMETERS BY PROGRAM NAME */
        /*--------------------------------*/
             CALL       PGM(EJKR11) PARM('R' &DKB &PTNR &JYKB &LEN)
        /*  'R' '888' 'FORD        ' 'FD' '512' */

           /*--------------------------*/
           /* REGISTER RECEPTION FILE  */
           /*--------------------------*/
             CALL       PGM(EJKC18) PARM(&JYKB &DKB &SFILE &SLIBL +
                          &LEN &HOST &PTNR)

@END:
           /*--------------------------*/
           /*  UNLOCK MULTIPLE CONTROL */
           /*--------------------------*/
             CALL       PGM(APLR81) PARM(&PIPGMN)
END2:
             ENDPGM
