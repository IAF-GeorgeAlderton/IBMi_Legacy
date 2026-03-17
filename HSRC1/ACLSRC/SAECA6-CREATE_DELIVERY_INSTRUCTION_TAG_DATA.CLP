             PGM
             /**EAEC01*******************************************/
             /*    納入指示エフの　作成                       */
             /*              K.NAKAMURA            H3.3.22      */
             /*******************************************EAEC01**/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USS) TYPE(*CHAR) LEN(2)
             RTVJOBA    JOB(&WS)  USER(&US)
             RTVNETA    SYSNAME(&PSYS)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             CHGVAR     VAR(&USS) VALUE(%SST(&US 1 2))
             OVRDBF     FILE(EAEWP06) TOFILE(TAKE/JYU75000)

             OVRPRTF    FILE(EAEPRA6) PAGESIZE(20 132) OVRFLW(20) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(D612) +
                          HOLD(*YES) IGCCPI(*CPI)
             CHGVAR     VAR(&PSYS) VALUE('AOYAMA  ')
             CHGVAR     VAR(&USS)  VALUE('A4')
     /*     納入指示エフ（青山製作所）４１２４出力　 */
             CALL       PGM(EAERA6) PARM(&PSYS &USS)
             ENDPGM
