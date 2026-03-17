             PGM
             /** AFBC90 ******************************************/
             /*  COMPONENTS PARTS SCAN DATA SUMMARIZE PROCESS    */
             /*  <LOCAL PROCURMENT SYSTEM>                       */
             /*  CREATE DATE  2000.11.28                         */
             /****************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID)  USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     SWS(00000000)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(AFBR90) PARM(&USER)

             ENDPGM
