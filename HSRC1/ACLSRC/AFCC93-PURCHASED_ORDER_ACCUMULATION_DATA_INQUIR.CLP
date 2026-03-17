             PGM
             /***AFCC93 ****************************************/
             /* PURCHASED ORDER ACCUMULATION DATA INQUIRY      */
             /*  ( MATERIAL)                                   */
             /*  TCH N.HYOTO 2001.06.29                        */
             /*************************************** AFCC93 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(AFCR93) PARM(&USER)

             ENDPGM
