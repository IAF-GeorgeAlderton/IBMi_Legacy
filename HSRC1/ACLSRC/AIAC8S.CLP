             PGM     /* PARM(&LOCATION &PC_SYS) */

             DCL        VAR(&LOCATION) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PC_SYS) TYPE(*CHAR) LEN(2)

             DCL        VAR(&PSTS) TYPE(*CHAR) LEN(1) /* STATUS */
             DCL        VAR(&PKFLG) TYPE(*CHAR) LEN(20) /* STATUS */
             DCL        VAR(&PFILE) TYPE(*CHAR) LEN(10) /* SEND FILE */
             DCL        VAR(&PSFLG) TYPE(*CHAR) LEN(1) /* SEND FLG */
             DCL        VAR(&PUALL) TYPE(*CHAR) LEN(116) /* FLG */

             DCL        VAR(&FTP_LIB) TYPE(*CHAR) LEN(10)

             DCL        VAR(&RQ_TMP) TYPE(*CHAR) LEN(10) /*PC->AS*/
             DCL        VAR(&HD_TMP) TYPE(*CHAR) LEN(10) /*AS->PC*/

             CHGVAR     VAR(&LOCATION) VALUE('0111')
             CHGVAR     VAR(&FTP_LIB) VALUE('APICSFTP')
             CHGVAR     VAR(&PC_SYS) VALUE('SJ')

             CHGVAR     VAR(&RQ_TMP) VALUE('RQ0111SJE')
             CHGVAR     VAR(&HD_TMP) VALUE('HD0111SJE')

             OVRDBF     FILE(INPUT) TOFILE(&FTP_LIB/&RQ_TMP)
             OVRDBF     FILE(OUTPUT) TOFILE(&FTP_LIB/&HD_TMP)
             CALL       PGM(AIAR81) PARM(&PSTS &LOCATION &PC_SYS +
                          &PKFLG &PFILE &PSFLG &PUALL)
             DLTOVR     FILE(INPUT)
             DLTOVR     FILE(OUTPUT)

             ENDPGM
