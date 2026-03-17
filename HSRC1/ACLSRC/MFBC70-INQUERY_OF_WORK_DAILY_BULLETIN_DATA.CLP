             PGM
             /** MFBC70 ************************************/
             /* ..INQUERY OF WORK DAILY BULLETIN DATA..    */
             /*       CREATE DATE : 1997.11.25             */
             /*       AUTHOR      : K.OKACHI.              */
             /**********************************************/
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)

             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)

             CALL MFBR70

             ENDPGM
