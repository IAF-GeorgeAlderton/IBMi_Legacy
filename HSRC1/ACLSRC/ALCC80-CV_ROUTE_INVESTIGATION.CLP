             PGM
            /**** ALCC80 ********************************************/
            /* CV ROUTE INVESTIGATION                               */
            /*   KIRI                                    2019.10.25 */
            /********************************************************/
             DCLF       FILE(ALCPW80)
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)     TYPE(*CHAR) LEN(8)

             DCL        VAR(&ALCWP80)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC    )  TYPE(*DEC ) LEN(10 0)
             DCL        VAR(&FNAM)     TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

 STP01:
             SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN31) VALUE('0')

             IF         COND(&IN01 *EQ '1') THEN(GOTO @END)

             IF         COND(&D1NO *EQ '1') THEN(GOTO STP02)
             IF         COND(&D1NO *EQ '2') THEN(GOTO STP02)
             IF         COND(&D1NO *EQ '3') THEN(GOTO STP02)
             IF         COND(&D1NO *EQ '4') THEN(GOTO STP02)

             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN31) VALUE('1')
             CHGVAR     VAR(&D1ERR) VALUE('KANBAN TYPE ERROR.')
             GOTO       STP01

 STP02:
             IF         COND(&IN05 *EQ '0') THEN(GOTO STP01)

             CHGVAR     VAR(&ALCWP80) +
                         VALUE('ALCWP80' *CAT %SST(&WSID 1 3))

             DLTF       FILE(&WLIB/&ALCWP80)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ALCWP80) RCDLEN(512) +
                          OPTION(*NOLIST *NOSRC) SIZE(90000 1000 +
                          3) LVLCHK(*NO) AUT(*ALL)

             IF         COND(&D1NO *EQ '1') THEN(GOTO STP10)
             IF         COND(&D1NO *EQ '2') THEN(GOTO STP20)
             IF         COND(&D1NO *EQ '3') THEN(GOTO STP30)
             IF         COND(&D1NO *EQ '4') THEN(GOTO STP40)


 STP10:    /*------------------------------------------------*/
           /*       PRODUCTION KANBAN                        */
           /*------------------------------------------------*/
             OVRDBF     FILE(ALCWP80) TOFILE(&WLIB/&ALCWP80)
             CALL       PGM(ALCR80)
             CHGVAR     VAR(&FNAM) VALUE('CV_PRODUCTION')
             GOTO       STP99

 STP20:    /*------------------------------------------------*/
           /*       HEAT TREATMENT KANBAN                    */
           /*------------------------------------------------*/
             OVRDBF     FILE(ALCWP80) TOFILE(&WLIB/&ALCWP80)
             CALL       PGM(ALCR81)
             CHGVAR     VAR(&FNAM) VALUE('CV_HEAT TREATMENT')
             GOTO       STP99

 STP30:    /*------------------------------------------------*/
           /*       PLATING KANBAN                           */
           /*------------------------------------------------*/
             OVRDBF     FILE(ALCWP80) TOFILE(&WLIB/&ALCWP80)
             CALL       PGM(ALCR82)
             CHGVAR     VAR(&FNAM) VALUE('CV_PLATING')
             GOTO       STP99

 STP40:    /*------------------------------------------------*/
           /*       PART WITHDRAWAL KANBAN                   */
           /*------------------------------------------------*/
             OVRDBF     FILE(ALCWP80) TOFILE(&WLIB/&ALCWP80)
             CALL       PGM(ALCR83)
             CHGVAR     VAR(&FNAM) VALUE('CV_PART WITHDRAWAL')
             GOTO       STP99

           /*------------------------------------------------*/
           /*------------------------------------------------*/
 STP99:

             RTVMBRD    FILE(&WLIB/&ALCWP80) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
                 /*転送処理*/
             CALL       PGM(APLC94) PARM('1' &ALCWP80 &WLIB +
                          &FNAM 'Y' ' ' 'Y')
             ENDDO

             CHGVAR     VAR(&D1NO) VALUE(' ')
             GOTO       STP01

 @END:       ENDPGM

