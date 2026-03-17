             PGM
             /**RCLCP6*******************************************/
             /* OUTGOING VOTE DATA INPUT                    */
             /*            M-OKUDA        1984.07.09            */
             /*******************************************RCLCP6**/
             DCLF       FILE(RCLPWP6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)

 STP1:       CHGVAR     VAR(&IN01) VALUE('0')
             CHGVAR     VAR(&@NO) VALUE(' ')
             SNDRCVF    DEV(&WSID) RCDFMT(RCLPWP61)
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

            /* MANUAL INPUT */
             IF         (&@NO *EQ '1') DO
             CALL       PGM(RCLR61)
             GOTO       CMDLBL(STP1)
             ENDDO

            /* BAR CODE INPUT */
             IF         (&@NO *EQ '2') DO
             CALL       PGM(RCLR62)
             GOTO       CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                        VALUE('INPUT SELECT NO.')
             GOTO       CMDLBL(STP1)

 END:        ENDPGM
