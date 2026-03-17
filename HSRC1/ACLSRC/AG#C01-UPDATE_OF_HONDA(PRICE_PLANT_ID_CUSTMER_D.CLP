             PGM
             /** AG#C01 ******************************************/
             /* UPDATE OF HONDA(PRICE PLANT ID-> CUSTMER.DELVERY)*/
             /*  KIRI 15.09.29                                   */
             /****************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

 @STP01:
             CALL       PGM(AG#R01)


 @END:
             ENDPGM
