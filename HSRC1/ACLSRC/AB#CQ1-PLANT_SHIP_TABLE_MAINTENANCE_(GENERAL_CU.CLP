             PGM
             /** AB#CQ1 ******************************************/
             /*  PLANT+SHIP TABLE MAINTENANCE (GENERAL CUSTOMERS)*/
             /*  J.WATANABE   2019.01.25                         */
             /****************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

 @STP01:
             CALL       PGM(AB#RQ1)


 @END:
             ENDPGM
