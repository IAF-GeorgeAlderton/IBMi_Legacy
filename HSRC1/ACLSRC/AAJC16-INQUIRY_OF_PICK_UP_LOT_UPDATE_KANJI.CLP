             PGM
             /** AAJC16 ************************************/
             /* INQUIRY OF PICK-UP LOT  UPDATE <KANJI> */
             /* <INTRA-PROCESS LOCATION CODE M/F  > */
             /* C:N.HAYAKAWA                      86.09.16 */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BN1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BN2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BN3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BN4) TYPE(*CHAR) LEN(1)
             DCL        VAR(&YY1) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MM1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DD1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BB1) TYPE(*CHAR) LEN(2)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
 STEP02:     CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AAJR16) PARM(&BN1 &BN2 &BN3 &BN4 &YY1 +
                          &MM1 &DD1 &BB1)
             CHGJOB     OUTQ(&PRT)
 END:        ENDPGM
