             PGM
             /** AGAC40 ***************************************/
             /* BATCH CHANGE OF CYCLE OF MAKING TO UNIFORMITY */
             /*    A-IDOTA     1990.06.06                     */
             /*************************************** AGAC40 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     RUNPTY(40)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(AGAR40)

             CHGJOB     RUNPTY(20)

             ENDPGM
