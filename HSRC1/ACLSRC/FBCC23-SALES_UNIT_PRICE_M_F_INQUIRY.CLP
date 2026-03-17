             PGM
             /** FBCC23 **********************************/
             /*     SALES UNIT PRICE M/F INQUIRY         */
             /*     (ORDER BY CUSTOMER / USER PARTS NO)  */
             /*        MSK KUNIEDA     2000.04.07        */
             /********************************** FBCC23 **/
             DCLF       FILE(FBCPW23)
             DCL        VAR(&US)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WS) USER(&US)
             CHGVAR     VAR(&WSID) VALUE(%SST(&WS 1 1))

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)
             CHGVAR     VAR(&PCMD) VALUE(' ')

 STP1:       SNDRCVF    DEV(&WS) RCDFMT(FBCPW231)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&@ERR) VALUE('                           ')

             IF         (&@NO *EQ ' ') DO
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('NO. ISN''T INPUT.')
             GOTO       STP1
             ENDDO

             IF         COND(&@NO *NE '1' *AND &@NO *NE '2') THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('NO. IS (1 2) ')
             GOTO       STP1
             ENDDO

           /*---------------------------------------*/
           /*  UNIT PRICE M/F INQUIRY               */
           /*---------------------------------------*/

             IF         (&@NO *EQ '1') DO
    /*       CALL       PGM(FBCR24) PARM(&PCMD)     */
             CALL       PGM(FBCR29) PARM(&PCMD)
             CHGVAR     VAR(&@NO)  VALUE(' ')
               IF     (&PCMD *EQ '3') DO
                  GOTO STP1
               ENDDO
             GOTO END
             ENDDO

           /*---------------------------------------*/
           /*  EXCEPTION UNIT PRICE M/F INQUIRY     */
           /*---------------------------------------*/

             IF         (&@NO *EQ '2') DO
             CALL       PGM(FBCR25) PARM(&PCMD)
             CHGVAR     VAR(&@NO)  VALUE(' ')
               IF     (&PCMD *EQ '3') DO
                  GOTO STP1
               ENDDO
             GOTO END
             ENDDO

 END:        ENDPGM
