             PGM
             /** AFEC10 ****************************/
             /* APICS INVENTORY INQUIRY            */
             /*              AUG/07/02             */
             /*                                    */
             /**************************** AFEC10 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID)  USER(&USER)


             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)


             CALL       PGM(AFER10)

             ENDPGM
