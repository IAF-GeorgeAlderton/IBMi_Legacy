             PGM
             /** MRHC81 **********************************/
             /*  2ND SURFACE TREATMENT MASTER EDIT       */
             /*    A.SHIBATA     2014.02.22              */
             /********************************************/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(MRHR81)

             ENDPGM
