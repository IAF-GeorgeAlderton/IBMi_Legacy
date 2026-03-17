             PGM
             /** AIAC60 ************************************/
             /*    AS400<=>APICS間ＪＯＢＬＯＧの照会 　*/
             /*          A-INOUE        2004.08.09         */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&AFSFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AFSSRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AFSWFILE) TYPE(*CHAR) LEN(10)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STEP02:     CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AIAR60)
             CHGJOB     OUTQ(&PRT)
 END:        ENDPGM
