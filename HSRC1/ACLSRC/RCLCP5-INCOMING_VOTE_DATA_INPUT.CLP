             PGM
             /**RCLCP5*******************************************/
             /* INCOMING VOTE DATA INPUT                     */
             /*            S.YAMAGAMI 1996.02.15                */
             /*******************************************RCLCP5**/
             DCLF       FILE(RCLPWP5)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

 STP1:       CHGVAR     VAR(&IN01) VALUE('0')
             CHGVAR     VAR(&@NO) VALUE(' ')
             SNDRCVF    DEV(&WSID) RCDFMT(RCLPWP51)
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

            /* MANUAL INPUT */
             IF         (&@NO *EQ '1') DO
             CALL       PGM(RCLR51) PARM(&USER)
             GOTO       CMDLBL(STP1)
             ENDDO

            /* BAR CODE INPUT */
             IF         (&@NO *EQ '2') DO
             CALL       PGM(RCLR52) PARM(&USER)
             GOTO       CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                        VALUE('INPUT SELECT NO.')
             GOTO       CMDLBL(STP1)

 END:        ENDPGM
