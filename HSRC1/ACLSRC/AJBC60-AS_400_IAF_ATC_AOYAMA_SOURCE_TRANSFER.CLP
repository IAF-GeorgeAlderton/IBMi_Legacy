             PGM
             /** AJBC60 ****************************************/
             /*  ..AS/400 IAF ATC<-->AOYAMA SOURCE TRANSFER..  */
             /*    I-HASADA                        97.09.19    */
             /**************************************** AJBC60 **/
             DCLF       FILE(AJBPW60)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSYN) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PIN98) TYPE(*CHAR) LEN(1) VALUE('0')
             RTVNETA    SYSNAME(&PSYN)

             IF         (&PSYN *EQ 'IAFAYM  ') DO
             CHGVAR     VAR(&IN98) VALUE('1')
             CHGVAR     VAR(&PIN98) VALUE('1')
             ENDDO

 STP1:       SNDRCVF    RCDFMT(AJBPW601)
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

             IF         (&AANO *EQ ' ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('ＮＯを入力しなさい。')
             GOTO       STP1
             ENDDO

             IF         ((&AANO *NE '1') *AND (&AANO *NE '2')) DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('ＮＯは、＜１・２＞。')
             GOTO       STP1
             ENDDO

             IF         (&AANO *EQ '1') DO
             CHGVAR     VAR(&PCMD) VALUE(' ')
             CALL       PGM(AJBR60) PARM(&PCMD &PIN98)

             IF         ((&PCMD *EQ '2') *OR (&PCMD *EQ '5')) DO
             CHGVAR     VAR(&AANO) VALUE(' ')
             GOTO       STP1
             ENDDO
             ENDDO

             IF         (&AANO *EQ '2') DO
             CHGVAR     VAR(&PCMD) VALUE(' ')
             CALL       PGM(AJBR61) PARM(&PCMD &PIN98)

             IF         ((&PCMD *EQ '2') *OR (&PCMD *EQ '5')) DO
             CHGVAR     VAR(&AANO) VALUE(' ')
             GOTO       STP1
             ENDDO
             ENDDO

 END:        ENDPGM
