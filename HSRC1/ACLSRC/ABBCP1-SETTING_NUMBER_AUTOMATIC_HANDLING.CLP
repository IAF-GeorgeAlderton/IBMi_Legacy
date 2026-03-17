             PGM
             /** ABBCP1 *********************************/
             /*  ..SETTING NUMBER AUTOMATIC HANDLING..  */
             /*     I-HASADA               86.10.01     */
             /********************************* ABBCP1 **/
             DCLF       FILE(ABBPW01)
             DCL        VAR(&ABBDS1) TYPE(*CHAR) LEN(54)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYMD) TYPE(*CHAR) LEN(6)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&PYMD)
             RTVDTAARA  DTAARA(ABBDS1) RTNVAR(&ABBDS1)
             RTVJOBA    JOB(&WSID)
             CHGJOB     RUNPTY(40)

             CHGVAR     VAR(%SST(&PYM 3 4)) VALUE(%SST(&PYMD 1 4))
             CHGVAR     VAR(%SST(&PYM 1 2)) VALUE('19')
             IF         (%SST(&PYM 3 2) *LT '97') DO
             CHGVAR     VAR(%SST(&PYM 1 2)) VALUE('20')
             ENDDO

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ABBPW011)

             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

             IF         ((%SST(&ABBDS1 27 1)) *NE 'Y') DO
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1

             CHGVAR     VAR(&PKBN) VALUE('A')

             CALL       PGM(ABBCJ1) PARM(&PKBN &PYM)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
