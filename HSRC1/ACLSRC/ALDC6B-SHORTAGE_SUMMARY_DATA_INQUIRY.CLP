             PGM
             /** ALDC6B ************************************/
             /* SHORTAGE SUMMARY DATA INQUIRY              */
             /*  KIRI                           2019.03.07 */
             /**********************************************/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)


             RTVJOBA    JOB(&WSID)   USER(&US)

             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01)  PARM(&WSID &PDEVT &PIGCD)
             CHGJOB     OUTQ(&PRTG)

             /**************************************/
             /*                                    */
             /**************************************/

             CALL       PGM(ALDR6B)


 END:        ENDPGM
