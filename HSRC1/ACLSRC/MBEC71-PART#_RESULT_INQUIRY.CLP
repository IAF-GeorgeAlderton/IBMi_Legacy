             PGM
             /*** MBEC71 ***********************************/
             /* PART NUMBER RESULT INQUIRY                           */
             /*            M-OKUDA        1985.02.11       */
             /**********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)

             DCL        VAR(&HIN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&YYYY) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRT)
             CALL       PGM(MBER71)   PARM(&HIN1 +
                                           &HIN2 +
                                           &HIN3 +
                                           &YYYY )
             ENDPGM
