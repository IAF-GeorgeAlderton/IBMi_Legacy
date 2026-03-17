             PGM
             /** SFAR11 ********************************************/
             /* CUSTOMER CONTRACT M/F                              */
             /*            M-OKUDA         1985.01.16              */
             /******************************************************/
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             RTVJOBA    JOB(&WSID)  USER(&US)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(KFAR11) PARM(&US)
             ENDPGM
