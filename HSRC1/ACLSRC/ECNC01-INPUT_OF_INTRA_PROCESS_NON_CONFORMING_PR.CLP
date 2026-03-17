             PGM
             /** ECNC01 ************************************/
             /* INPUT OF INTRA-PROCESS NON-CONFORMING PRODUCT EXPLANATION */
             /* MATERIAL */
             /*        I-HASADA            87.04.02        */
             /************************************ ECNC01 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(ECNR01) PARM(&USER)
             ENDPGM
