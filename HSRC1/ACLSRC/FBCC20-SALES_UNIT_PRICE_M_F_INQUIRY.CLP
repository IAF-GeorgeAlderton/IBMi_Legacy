             PGM
             /** FBCC20 **********************************/
             /*  SALES UNIT PRICE M/F INQUIRY            */
             /*  MSK KUNIEDA     2000.04.05              */
             /*-----------------------------------       */
             /*  JW    2023.06.21 ADD OPT3 AND 4         */
             /********************************************/
             DCLF       FILE(FBCPW20)
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

 STP1:       SNDRCVF    DEV(&WS) RCDFMT(FBCPW201)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&@ERR) VALUE('                           ')

             IF         (&@NO *EQ ' ') DO
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('ENTER OPTION NUMBER!')
             GOTO       STP1
             ENDDO

             IF         COND(&@NO *NE '1' *AND &@NO *NE '2' *AND +
                          &@NO *NE '3' *AND &@NO *NE '4') THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('OPTION# SHOULD BE 1, 2, 3 +
                          or 4!')
             GOTO       STP1
             ENDDO

           /*---------------------------------------*/
           /*  UNIT PRICE M/F INQUIRY               */
           /*---------------------------------------*/

             IF         (&@NO *EQ '1') DO
             CALL       PGM(FBCR21) PARM(&PCMD)
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
             CALL       PGM(FBCR22) PARM(&PCMD)
             CHGVAR     VAR(&@NO)  VALUE(' ')
               IF     (&PCMD *EQ '3') DO
                  GOTO STP1
               ENDDO
             GOTO END
             ENDDO

           /*-JW1 ----------------------------------*/
           /* UNIT PRICE M/F INQ BY IAF PART# V.2   */
           /*---------------------------------------*/
             IF         (&@NO *EQ '3') DO
             CALL       PGM(FBCC21A) PARM(&PCMD)
             CHGVAR     VAR(&@NO)  VALUE(' ')
               IF     (&PCMD *EQ '3') DO
                  GOTO STP1
               ENDDO
             GOTO END
             ENDDO

           /*-JW1 ----------------------------------*/
           /* UNIT PRICE M/F INQ BY CUST PART# V.2  */
           /*---------------------------------------*/

             IF         (&@NO *EQ '4') DO
             CALL       PGM(FBCC29A) PARM(&PCMD)
             CHGVAR     VAR(&@NO)  VALUE(' ')
               IF     (&PCMD *EQ '3') DO
                  GOTO STP1
               ENDDO
             GOTO END
             ENDDO

 END:        ENDPGM
