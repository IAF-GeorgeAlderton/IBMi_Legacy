             PGM
             /** EJBC01T ************************************/
             /*  R850FCO    RECEIVING PROCESS <TEST>        */
             /* THIS IS AUTOMATICALLY PROCESSED BY HULFT    */
             /*    T.SAKAKI                   2016.10.13    */
             /************************************ EJBC01T **/
             DCL        VAR(&JYKB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DKB) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POWSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PTTL)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

        /* CHGLIBL */
             CHGLIBL    LIBL(QGPL QTEMP QMGU QPCFSU TOBJ1 TFILE1 +
                          TWFILE1 TJRN1 HSRC1)

        /* PROGRAM NAME */
             CHGVAR     VAR(&PIPGMN) VALUE('EJBC01    ')

        /*----------------------------------------------------*/
        /* CHECK AND ADD MULTIPLE PROCESS CONTROL FILE        */
        /*     POSTTS = '1'  OK- CAN PROCESS                  */
        /*            = '2'  NG- PROCESSING BY OTHERS         */
        /*----------------------------------------------------*/
             CALL       PGM(APLR80) PARM(&PIPGMN &POWSID &POUSID +
                          &POKONA &POSTTS)
          IF         COND(&POSTTS *EQ '2') THEN(DO)
             CHGVAR     VAR(&PTTL) VALUE('HULFT_RCV GOT AN ERROR +
                          AT ' *CAT &PIPGMN)
             CHGVAR     VAR(&PMSG) VALUE('HULFT_RCV WAS FAILED. +
                          PLEASE CHECK AND TAKE CARE OF IT. PROGRAM +
                          IS ' *CAT &PIPGMN *CAT '-> AND +
                          THEN,UNLOCK MULTIPLE PROCESS CONTROL FILE +
                          BY CALL APLR84')
        /* NOTIFICATION BY E-MAIL */
             CALL       PGM(MSGC10) PARM(&PTTL &PMSG)
             GOTO       CMDLBL(END2)
          ENDDO

        /*--------------------------------*/
        /* GET PARAMETERS BY PROGRAM NAME */
        /*--------------------------------*/
             CALL       PGM(EJKR11) PARM(&PIPGMN &JYKB &DKB &RCV +
                          &SFILE &SLIBL)
        /* 'EJBC01' 'TS' '888' 'IAF-HULFT'*/

        /* RECORD COUNT */
             RTVMBRD    FILE(&SLIBL/&SFILE) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(@END))

        /* NOTIFICATION FOR TEST */
             SNDMSG     MSG('RECEIVED R856FCO ASN DATA <TEST>') TOMSGQ(V#IS1)

  /*       RECEIVING DIVISION = 'FD'                       */
  /*         CHGVAR     VAR(&JYKB) VALUE('FD')             */
  /*       EDI DATA CODE = 888                             */
  /*         CHGVAR     VAR(&DKB) VALUE('888')             */
  /*       RECEPTION LIBL/FILE                             */
  /*         CHGVAR     VAR(&SFILE) VALUE('EJBWP01   ')    */
  /*         CHGVAR     VAR(&SLIBL) VALUE(&WLIB)           */
  /*       COMMUNICATION TERMINAL                          */
  /*         CHGVAR     VAR(&RCV) VALUE('IAF-HULFT ')      */

           /*--------------------------*/
           /* REGISTER RECEPTION FILE  */
           /*--------------------------*/
             CALL       PGM(EJKC18) PARM(&JYKB &DKB &SFILE &SLIBL &RCV)
@END:
           /*--------------------------*/
           /*  UNLOCK MULTIPLE CONTROL */
           /*--------------------------*/
             CALL       PGM(APLR81) PARM(&PIPGMN)
END2:
             ENDPGM
