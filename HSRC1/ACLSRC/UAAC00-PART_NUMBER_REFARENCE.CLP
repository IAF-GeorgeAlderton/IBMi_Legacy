             /** UAAC00 *******************/
             /* ..PART NUMBER REFARENCE.. */
             /*     K.YASUDA  1999.09.17  */
             /******************* UAAC00 **/
             DCLF       FILE(UAAPW00)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)

 STP0:       CHGVAR     VAR(&NO1) VALUE(' ')
 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(UAAPW001)

             CHGVAR     VAR(&IN10) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

             IF         COND((&NO1 *NE '1') *AND (&NO1 *NE '2') *AND +
                          (&NO1 *NE '3')) THEN(DO)
             CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO.')
             GOTO       STP1
             ENDDO

             IF         (&NO1 *EQ '1') DO
             CALL       PGM(UAAR01)
             GOTO       STP0
             ENDDO

             IF         (&NO1 *EQ '2') DO
             CALL       PGM(UAAR02)
             GOTO       STP0
             ENDDO

             IF         (&NO1 *EQ '3') DO
             CALL       PGM(UAAR03)
             GOTO       STP0
             ENDDO

 END:        ENDPGM
