             PGM        PARM(&LIBL &FILE)
             /** EJRC01 **************************************/
             /* R856 FOR VENDOR ASN RECEIVING PROCESS <PROD> */
             /*    T.SAKAKI                      2016.10.13  */
             /************************************** EJRC01 **/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LEN) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&SUB1) TYPE(*CHAR) LEN(24)
             DCL        VAR(&VNM) TYPE(*CHAR) LEN(15)
             DCL        VAR(&PD) TYPE(*CHAR) LEN(1)

     /*--------------------------*/
     /*    CHECK ENVIRONMENT     */
     /*--------------------------*/
             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

     /*----------------------------------------*/
     /* MAIN PROGRAM TO GET CONTAINS FROM EDI  */
     /*  INPUT --> AFDPP60                     */
     /*----------------------------------------*/
             OVRDBF     FILE(EJRWP01) TOFILE(&LIBL/&FILE)
             OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1 ) FORMTYPE(K6H1) +
                          HOLD(*YES)
             CALL       PGM(EJRR01) PARM(&VNM &PD)
             DLTOVR     FILE(*ALL)

             CHGVAR     VAR(&SUB1) VALUE('ASN FROM ' *CAT &VNM)
     /*----------------------------------------*/
     /* SEND E-MAIL                            */
     /*----------------------------------------*/
             IF         COND(&PD *NE ' ') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(&WLIB/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(PRT132) TOFILE(&WLIB/PRT132B)
             CALL       PGM(AB#RW0)

             IF         COND(&USER *NE 'TEST') THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('forest-city-997@iafi.com')) +
                          DSTD(&SUB1) MSG('Please check the +
                          attached list. (EJRC01).') +
                          DOCFILE(&WLIB/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD(&SUB1)
             DLTOVR     FILE(PRT132)
             ENDDO

             ENDDO

     /*----------------------------------------*/
     /* UPDATE AFDPP20                         */
     /*  INPUT --> (AFDPP60) -> AFDPP20        */
     /*----------------------------------------*/

     /*  ??????????????????????????? */

@END:
             ENDPGM
