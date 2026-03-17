             PGM
             /** AFACBB *********************************/
             /*    DATA FORMAT CODE CONVERSION          */
             /*    PROGRAM ID.    :                     */
             /*    CREATE DATE.   :  SEP.26,'89.        */
             /*    AUTHOR.        :  K.NAKAMURA         */
             /********************************* AFACBB **/
             DCLF       FILE(AFAPWBB)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AFAPWBB1)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')


             IF         (&AANO *EQ ' ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PLEASE INPUT NUMBER.')
             GOTO       STP1
             ENDDO

             IF         (&AANO *NE '1' *AND &AANO *NE '2' ) DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PLEASE INPUT NUMBER +
                          CORRECTLY.')
             GOTO       STP1
             ENDDO

             IF         (&AAINF *EQ '          ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PLEASE INPUT THE INPUT FILE +
                          NAME.')
             GOTO       STP1
             ENDDO

             CHKOBJ     OBJ(&AAINF) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             IF         (&AAOUTF *EQ '          ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE INPUT FILE NAME IS NOT +
                          CORRECT.')
             GOTO       STP1
             ENDDO
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PLEASE INPUT THE OUTPUT +
                          FILE NAME.')
             GOTO       STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1

             DLTF       FILE(QTEMP/&AAOUTF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&AAOUTF) RCDLEN(4096) +
                          OPTION(*NOLIST) SIZE(10000 2000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(INPUT) TOFILE(&AAINF)
             OVRDBF     FILE(OUTPUT) TOFILE(&AAOUTF)

             IF         (&AANO *EQ '1') DO
             CALL       PGM(AFAR04)
             MONMSG     MSGID(CPF4101) EXEC(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PLEASE CONFIRM THE INPUT +
                          FILE NAME.')
             GOTO       STP1
             ENDDO
             ENDDO
             ELSE       DO

             CALL       PGM(AFAR09)
             MONMSG     MSGID(CPF4101) EXEC(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PLEASE CONFIRM THE INPUT +
                          FILE NAME.')
             GOTO       STP1
             ENDDO
             ENDDO

             DLTOVR     FILE(*ALL)

         /** DSPFL      FILE(&AAOUTF) **/
             EDTDTA     FILE(&AAOUTF)

 END:        ENDPGM
