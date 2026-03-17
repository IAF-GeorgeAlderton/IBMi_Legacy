             PGM
             /*** ECSCE1 *****************************************/
             /* DIE COMMENT M/F                                  */
             /*     Y.MAEDA           2019.03.20                 */
             /****************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1YMD1) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P1TIM1) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&P1YMD2) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P1TIM2) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&P1DIE1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1DIE2) TYPE(*CHAR) LEN(4)
             DCL        VAR(&P1DIE3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1DIE4) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1RIYU) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1MSNO) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1IOKB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1GSKB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1JUDG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FKEY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3)      TYPE(*CHAR) LEN(3)

             DCL        VAR(&OUTR)     TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&FRLB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&FRFL)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&HOST)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&TOFL)     TYPE(*CHAR) LEN(52)
             DCL        VAR(&TOFT)     TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3)     VALUE(%SST(&WSID 1 3))
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(ECSRE1)

 @END:       ENDPGM
