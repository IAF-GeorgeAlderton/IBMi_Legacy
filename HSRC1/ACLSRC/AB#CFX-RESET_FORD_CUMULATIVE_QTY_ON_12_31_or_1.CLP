             PGM
/*-----------------------------------------------------------*/
/* RESET FORD CUMULATIVE QTY                                 */
/* THIS PROGRAM SHOULD RUN BEFORE STARTING JOB ON THE DAY OF */
/* DEC 31, JAN 01 OR AUG 01                                  */
/*                                                           */
/* JW1 2017.01.04 FIX DATE SELECTION                         */
/*-----------------------------------------------------------*/
             DCLF       FILE(AB#PWFX)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&MMDD)   TYPE(*DEC) LEN(4)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)

             RTVJOBA    USER(&USER) DATE(&DATE)
             CHGVAR     VAR(&MMDD) VALUE(%SST(&DATE 3 4))
           /*--------------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)


@STRT:       SNDRCVF    RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@STRT))

             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&D@MSG) VALUE(*BLANK)

             IF         COND(&D@OPT *EQ '1') THEN(GOTO CMDLBL(STP2))
             IF         COND(&D@OPT *EQ '2') THEN(GOTO CMDLBL(STP3))
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&D@MSG) VALUE('PLEASE INPUT 1 OR 2 ')
             GOTO @STRT

 STP2:   /* JAN 1ST */
    /* JW1 IF         ((&MMDD *LE 1230) *OR (&MMDD *GE 0102)) THEN(DO)        */
    /*     CHGVAR     VAR(&IN99) VALUE('1')                                   */
    /*     CHGVAR     VAR(&D@MSG) VALUE('SHOULD BE PROCESSED AROUND JAN. 1ST')*/
    /*     GOTO @STRT                                                         */
    /*     ENDDO                                                              */
    /*     GOTO STP4                                                          */

    /* JW1 DEC31/JAN01 */
           IF     ((&MMDD *EQ 1231) *OR (&MMDD *EQ 0101)) THEN(DO)
           GOTO STP4
           ENDDO

           CHGVAR     VAR(&IN99) VALUE('1')
           CHGVAR     VAR(&D@MSG) VALUE('SHOULD BE PROCESSED ON +
                          DEC 31 or JAN 1ST')
           GOTO @STRT

 STP3:   /* AUG 1ST */
             IF         (&MMDD *NE 801) THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&D@MSG) VALUE('SHOULD BE PROCESSED ON AUG. 1ST')
             GOTO @STRT
             ENDDO
             GOTO STP4

 STP4:       CPYF       FROMFILE(&PLIB/ABFAP01) +
                          TOFILE(&WLIB/ABFAP01BK) MBROPT(*REPLACE) +
                          CRTFILE(*YES)

             IF         COND(&USER *NE 'TEST') THEN(DO)
             SNDDST     TYPE(*LMSG) +
                          TOINTNET(('AS400-SYSTEM@IAFI.COM')) +
                          DSTD('START FORD CUM RESET PROCESS') +
                          LONGMSG('START FORD CUM RESET PROCESS') +
                          DOCD('START FORD CUM RESET PROCESS')
                        ENDDO

             CALL       PGM(AB#RFX) PARM(&D@OPT)

             IF         COND(&USER *NE 'TEST') THEN(DO)
             SNDDST     TYPE(*LMSG) +
                          TOINTNET(('AS400-SYSTEM@IAFI.COM')) +
                          DSTD('END FORD CUM RESET PROCESS') +
                          LONGMSG('END FORD CUM RESET PROCESS') +
                          DOCD('END FORD CUM RESET PROCESS')
                        ENDDO

@END:
             ENDPGM
