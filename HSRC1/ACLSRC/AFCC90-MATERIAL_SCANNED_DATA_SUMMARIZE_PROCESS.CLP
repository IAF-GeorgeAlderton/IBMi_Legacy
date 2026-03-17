             PGM
             /** AFCC90 ******************************************/
             /*  MATERIAL SCANNED DATA SUMMARIZE PROCESS         */
             /*      <LOCAL PROCURMENT SYSTEM>                   */
             /*    CREATE DATE  2001.06.22                       */
             /****************************************** AFCC90 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID)  USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(AFCR90) PARM(&USER)

 @END:       ENDPGM
