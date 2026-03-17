             PGM
             /** EJKC33 *************************************/
             /* INQUIRY & UPDATE B2B_R MANAGEMENT FILE      */
             /*    **ORIGINAL IS JK590C FROM ASJ**          */
             /*   T.SAKAKI              2016.12.13          */
             /************************************ EJKC33 ***/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(EJKR33)

             ENDPGM
