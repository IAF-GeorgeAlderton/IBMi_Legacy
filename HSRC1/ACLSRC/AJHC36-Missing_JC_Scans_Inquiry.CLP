             PGM
             /*** AJHC36 ************************************************/
             /* MISSING JC SCANS FROM RESULTS UPLOAD INQUIRY            */
             /* LEC : 2024.06.25                                        */
             /***********************************************************/
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AJHR36 )

 END:        ENDPGM
