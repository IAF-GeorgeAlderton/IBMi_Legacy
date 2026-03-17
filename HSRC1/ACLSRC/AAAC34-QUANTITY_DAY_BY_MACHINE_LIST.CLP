             PGM
             /** AAAC34 **********************************************/
             /*  QUANTITY / DAY BY MACHINE LIST                      */
             /*                                                      */
             /*  TCH 00.08.03                                        */
             /********************************************** AAAC34 **/
             DCLF       FILE(AAAPW34)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDAY) TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&NDAY) TYPE(*DEC)  LEN(2 0)

             RTVJOBA    JOB(&WSID) USER(&USR)

             CHGVAR     VAR(&YEAR) VALUE(0)
             CHGVAR     VAR(&MM)   VALUE(0)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AAAPW341)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

             IF         (&YEAR *NE 0) GOTO STP2
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       STP1

 STP2:
             IF         ((&MM *GE 1) *AND (&MM *LE 12)) GOTO STP3
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       STP1


 STP3:
             IF         (&IN05 *EQ '0') GOTO STP1

             CLRPFM     FILE(AAAWP33)
             MONMSG     MSGID(CPF0000)

             OVRPRTF    FILE(QPRINT) SAVE(*YES)
             CALL       PGM(AAAR33) PARM(&USR &YEAR &MM &PDAY &NDAY)
             DLTOVR     FILE(*ALL)

             CALL       PGM(AAAR35) PARM(&YEAR &MM &USR &PDAY &NDAY)

 END:        ENDPGM
