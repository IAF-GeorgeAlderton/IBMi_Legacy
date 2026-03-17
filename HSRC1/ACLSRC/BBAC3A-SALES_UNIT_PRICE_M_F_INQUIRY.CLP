             PGM
             /** BBAC3A **********************************/
             /*          SALES UNIT PRICE M/F INQUIRY || */
             /*        M...              91.03.07        */
             /********************************** BBAC3A **/
             DCLF       FILE(BBAPW3A)
             DCL        VAR(&US)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NO)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&KBN)   TYPE(*CHAR) LEN(1)
             CHGVAR     VAR(&KBN)  VALUE(' ')

             RTVJOBA    JOB(&WS) USER(&US)
             CHGVAR     VAR(&WSID) VALUE(%SST(&WS 1 1))

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

 STP1:       SNDRCVF    DEV(&WS) RCDFMT(BBAPW3A1)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&NO *EQ ' ') DO
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('NO. ISN''T INPUT.')
             GOTO       STP1
             ENDDO

             IF         COND(&NO *NE '1' *AND &NO *NE '2' *AND &NO +
                          *NE '3' *AND &NO *NE '4') THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('NO. IS 1 2 3 4')
             GOTO       STP1
             ENDDO

             IF         (&NO *EQ '1') DO
             CALL       PGM(BBAR31) PARM(&KBN)
             IF         (&KBN *EQ '3') DO
             CHGVAR     VAR(&NO)  VALUE(' ')
             CHGVAR     VAR(&KBN) VALUE(' ')
             GOTO STP1
             ENDDO
             ENDDO

             IF         (&NO *EQ '2') DO
             CALL       PGM(BBAR32) PARM(&KBN)
             IF         (&KBN *EQ '3') DO
             CHGVAR     VAR(&NO)  VALUE(' ')
             CHGVAR     VAR(&KBN) VALUE(' ')
             GOTO STP1
             ENDDO
             ENDDO

             IF         (&NO *EQ '3') DO
             CALL       PGM(BBAR33) PARM(&KBN)
             IF         (&KBN *EQ '3') DO
             CHGVAR     VAR(&NO)  VALUE(' ')
             CHGVAR     VAR(&KBN) VALUE(' ')
             GOTO STP1
             ENDDO
             ENDDO

             IF         (&NO *EQ '4') DO
             CALL       PGM(BBAR34) PARM(&KBN)
             IF         (&KBN *EQ '3') DO
             CHGVAR     VAR(&NO)  VALUE(' ')
             CHGVAR     VAR(&KBN) VALUE(' ')
             GOTO STP1
             ENDDO
             ENDDO

 END:        ENDPGM
