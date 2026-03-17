             PGM
             /** AB#CH1 ******************************************/
             /* UPDATE OF HONDA (PLANT+SHIP -> CUSTMER.DELVERY)  */
             /*  KIRI 15.08.20                                   */
             /****************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

 @STP01:
             CALL       PGM(AB#RH1)


 @END:
             ENDPGM
