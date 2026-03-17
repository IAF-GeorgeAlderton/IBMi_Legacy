             PGM
             /*** GAHC35 ************************************/
             /*  UPDATE OF CARRIER M/F                      */
             /*   KIRI              2017.06.29              */
             /***********************************************/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)     TYPE(*CHAR) LEN(8)


             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     OUTQ(&PRTG)

             CALL       GAHR35

 END:
             ENDPGM
