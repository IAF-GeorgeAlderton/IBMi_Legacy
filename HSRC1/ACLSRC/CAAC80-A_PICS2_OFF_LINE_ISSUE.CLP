             PGM
             /** CAAC80 **************************/
             /* A-PICS2オフライン              */
             /* A-PICS2 OFF-LINE ISSUE           */
             /*      T.SAKASHITA 2020.09.28      */
             /************************** CAAC20 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CAAWP05) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CABPP01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CABPP80) TYPE(*CHAR) LEN(10)

             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSDT) TYPE(*DEC) LEN(8 0) VALUE(0)

             DCL        VAR(&QDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(8)

             DCL        VAR(&TITL) TYPE(*CHAR) LEN(40)
             DCL        VAR(&TEXT1) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TEXT2) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TEXT3) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TEXT4) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TEXT5) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TEXT6) TYPE(*CHAR) LEN(50)

             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&QDATE)
             CVTDAT     DATE(&QDATE) TOVAR(&SDATE) FROMFMT(*SYSVAL) +
                          TOFMT(*YYMD) TOSEP(*NONE)

    /********************************/
    /* CHECK LIBRARY                */
    /********************************/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

    /********************************/
    /* INPUT DATE                   */
    /********************************/
             CHGVAR     VAR(&TITL) VALUE(' * * * A-PICS2/3 OFF-LINE +
                          ORDER * * * ')
             CHGVAR     VAR(&TEXT1) VALUE('PRODUCTION START DATE')
             CHGVAR     VAR(&TEXT2) +
                          VALUE('************************************+
                          *****')
             CHGVAR     VAR(&TEXT3) VALUE('* ISSUE DATE-BIN  ->  ' +
                          *CAT &SDATE *CAT ' - 88 BIN *')
             CHGVAR     VAR(&TEXT4) +
                          VALUE('************************************+
                          *****')
             CALL       PGM(INPR02) PARM(&TITL &TEXT1 &TEXT2 &TEXT3 +
                          &TEXT4 &TEXT5 &TEXT6 &PSDT &RTN)
             IF         COND(&RTN *NE 'IN') THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO

    /*********************************************/
    /* CREATE TEMP. A-PICS2 PART INFORMATION M.F */
    /*********************************************/
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&CAAWP05) VALUE('CAAWP05' *CAT &WS)
             CHGVAR     VAR(&CABPP01) VALUE('CABPP01' *CAT &WS)
             CHGVAR     VAR(&CABPP80) VALUE('CABPP80' *CAT &WS)

             DLTF       FILE(&CAAWP05)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CAAWP05) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(CAAWP05)

             DLTF       FILE(&CABPP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CABPP01) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(CABPP01)

             DLTF       FILE(&CABPP80)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CABPP80) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(CABPP80)

      /**    CPYF       FROMFILE(CABPP01) TOFILE(&CABPP80) MBROPT(*ADD)  */

             /* CABPP01 -> &CABPP80 */
             /* CABWP01 -> &CABPP80 */
             OVRDBF     FILE(CABPP80) TOFILE(&CABPP80)
             CALL       PGM(CABR89) PARM(&SDATE)

             /* ZERO SET TO BOXES */
             OVRDBF     FILE(CABPP80) TOFILE(&CABPP80)
             CALL       PGM(CABR80)

             /* SET PRODUCTION START DATE -> &CABPP80 */
             OVRDBF     FILE(CABPP80) TOFILE(&CABPP80)
             CALL       PGM(CABR85) PARM(&PSDT)

             /* UPDATE &CABPP80 */
             OVRDBF     FILE(CABPP80) TOFILE(&CABPP80)
             CALL       PGM(CABR82)

             /* &CABPP80 -> &CABPP01 */
             CPYF       FROMFILE(&CABPP80) TOFILE(&CABPP01) +
                          MBROPT(*REPLACE)

             /* &CABPP01 -> &CAAWP05 */
             OVRDBF     FILE(CABPP01) TOFILE(&CABPP01)
             OVRDBF     FILE(CAAWP05) TOFILE(&CAAWP05)
             CALL       PGM(CAAR04) PARM(&USER '0111' '88')

             RTVMBRD    FILE(&CAAWP05) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO

             /* CAAWP05 -> CAAPP05 */
             /*  CAAPP05 IS USED BY CAAC50 */
             OVRDBF     FILE(CAAWP05) TOFILE(&CAAWP05)
             CALL       PGM(CAAR05)

@END:
             ENDPGM
