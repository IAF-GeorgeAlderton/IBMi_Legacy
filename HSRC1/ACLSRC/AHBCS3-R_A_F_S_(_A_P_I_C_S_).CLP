             PGM
             /** AHBC02 ************************************/
             /* 工場間未納（Ａ－ＰＩＣＳ）状況の照会     */
             /*                              14.06.23      */
             /**********************************************/
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(AHBRS2) PARM('1' '     ' '     ' '  ')
 END:
             ENDPGM
