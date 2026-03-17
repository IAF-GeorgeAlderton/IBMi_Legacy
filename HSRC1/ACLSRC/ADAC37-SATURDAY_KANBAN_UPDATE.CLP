             PGM
             /** ADAC37 **************************/
             /*  SATURDAY KANBAN UPDATE                       */
             /************************** ADAC30 **/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(ADAR37)


             ENDPGM
