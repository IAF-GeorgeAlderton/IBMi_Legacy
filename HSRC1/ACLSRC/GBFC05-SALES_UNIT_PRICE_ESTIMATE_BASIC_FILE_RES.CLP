             PGM
             /*** GBFC05 *****************************************/
             /* SALES UNIT PRICE ESTIMATE BASIC FILE RESULT CLEAR */
             /*         H.ITO                  90.09.19          */
             /***************************************** GBFC05 ***/
             DCLF       FILE(GBFPW05)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&@CMT) +
                          VALUE('BEFORE THIS HANDLING, PLEASE EXIT ALL +
                          ESTIMATE CALCULATION')
 @001:       SNDRCVF    DEV(&WSID) RCDFMT(GBFPW051)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN80 *EQ '1') DO
             CALL       PGM(GGBR19)
             GOTO @001
             ENDDO

             IF         (&@TOKU = '    ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT  CUSTOMER.')
             GOTO @001
             ENDDO

             IF         (&@TKOJ = ' ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT  FACTORY.')
             GOTO @001
             ENDDO

             IF         (&IN05 *EQ '0') GOTO @001

             CALL       PGM(GBFR05) PARM(&@TOKU &@TKOJ)

 END:        ENDPGM
