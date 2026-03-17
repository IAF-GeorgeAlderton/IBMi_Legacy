             PGM
             /** VJBC20 ************************************/
             /*   ファイル再編成　　リスト               */
             /*   ファイル再編成登録マスター　クリアー   */
             /*      I-HASADA                87.11.04      */
             /*      A-INOUE 02.02.01 : DELETE VJBR20      */
             /************************************ VJBC20 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&VJBDS1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&QDATE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WORK)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WDATE) TYPE(*CHAR) LEN(8)

             RTVDTAARA  DTAARA(VJBDS1) RTNVAR(&VJBDS1)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&QDATE)
             RTVJOBA    JOB(&WSID)

  /*   YYYYMMDD  CONVERSION   */
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&QDATE)
             CVTDAT     DATE(&QDATE) TOVAR(&WORK) FROMFMT(*SYSVAL) +
                          TOFMT(*YYMD) TOSEP(*NONE)
             CHGVAR     VAR(&WDATE) VALUE(&WORK)

             IF         (%SST(&WDATE 1 6) *NE &VJBDS1) DO

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

       /*    OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +        */
       /*                 RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +*/
       /*                 IGCDTA(&PIGCD)        */
       /*    CALL       PGM(VJBR20) PARM('S')   */
       /*    DLTOVR     FILE(QPRINT)            */

             CALL       PGM(VJBR21)
             CHGVAR     VAR(&VJBDS1) VALUE(%SST(&WDATE 1 6))
             CHGDTAARA  DTAARA(VJBDS1) VALUE(&VJBDS1)

             ENDDO

             ENDPGM
