             PGM
             /***AFBC93 ****************************************/
             /* PURCHASED ORDER ACCUMULATION DATA INQUIRY      */
             /*  ( COMPONENTS )                                */
             /*  MSK KUNIEDA                 2000.12.14        */
             /*------------------------------------------------*/
             /*  JW     2024.06.19 CHG AFBR93 --> AFBR93A      */
             /*************************************** AFBC93 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

  /**JW1 *** CALL       PGM(AFBR93) PARM(&USER)  ***/
             CALL       PGM(AFBR93A)

             ENDPGM
